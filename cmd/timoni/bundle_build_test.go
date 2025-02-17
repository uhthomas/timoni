package main

import (
	"fmt"
	"os"
	"path/filepath"
	"strings"
	"testing"

	"github.com/fluxcd/pkg/ssa"
	. "github.com/onsi/gomega"
	"k8s.io/apimachinery/pkg/apis/meta/v1/unstructured"
)

func Test_BundleBuild(t *testing.T) {
	g := NewWithT(t)

	bundleName := "my-bundle"
	modPath := "testdata/module"
	namespace := rnd("my-namespace", 5)
	modName := rnd("my-mod", 5)
	modURL := fmt.Sprintf("%s/%s", dockerRegistry, modName)
	modVer := "1.0.0"

	// Push the module to registry
	_, err := executeCommand(fmt.Sprintf(
		"mod push %s oci://%s -v %s",
		modPath,
		modURL,
		modVer,
	))
	g.Expect(err).ToNot(HaveOccurred())

	bundleData := fmt.Sprintf(`
bundle: {
	apiVersion: "v1alpha1"
	name: "%[1]s"
	instances: {
		frontend: {
			module: {
				url:     "oci://%[2]s"
				version: "%[3]s"
			}
			namespace: "%[4]s"
			values: server: enabled: false
		}
		backend: {
			module: {
				url:     "oci://%[2]s"
				version: "%[3]s"
			}
			namespace: "%[4]s"
			values: client: enabled: false
		}
	}
}
`, bundleName, modURL, modVer, namespace)

	bundlePath := filepath.Join(t.TempDir(), "bundle.cue")
	err = os.WriteFile(bundlePath, []byte(bundleData), 0644)
	g.Expect(err).ToNot(HaveOccurred())

	t.Run("builds instances from bundle", func(t *testing.T) {
		execCommands := map[string]func() (string, error){
			"using a file": func() (string, error) {
				return executeCommand(fmt.Sprintf(
					"bundle build -f %s -p main",
					bundlePath,
				))
			},
			"using stdin": func() (string, error) {
				r := strings.NewReader(bundleData)
				return executeCommandWithIn("bundle build -f - -p main", r)
			},
		}

		for name, execCommand := range execCommands {
			t.Run(name, func(t *testing.T) {
				g := NewWithT(t)
				output, err := execCommand()
				g.Expect(err).ToNot(HaveOccurred())

				objects, err := ssa.ReadObjects(strings.NewReader(output))
				g.Expect(err).ToNot(HaveOccurred())
				g.Expect(objects).To(HaveLen(2))

				frontendClientCm, err := getObjectByName(objects, "frontend-client")
				g.Expect(err).ToNot(HaveOccurred())
				g.Expect(frontendClientCm.GetKind()).To(BeEquivalentTo("ConfigMap"))
				g.Expect(frontendClientCm.GetNamespace()).To(ContainSubstring(namespace))

				backendClientCm, err := getObjectByName(objects, "backend-server")
				g.Expect(err).ToNot(HaveOccurred())
				g.Expect(backendClientCm.GetKind()).To(BeEquivalentTo("ConfigMap"))
				g.Expect(backendClientCm.GetNamespace()).To(ContainSubstring(namespace))
			})
		}
	})
}

func getObjectByName(objs []*unstructured.Unstructured, name string) (*unstructured.Unstructured, error) {
	for _, obj := range objs {
		if obj.GetName() == name {
			return obj, nil
		}
	}
	return nil, fmt.Errorf("Object with name '%s' does not exist.", name)
}
