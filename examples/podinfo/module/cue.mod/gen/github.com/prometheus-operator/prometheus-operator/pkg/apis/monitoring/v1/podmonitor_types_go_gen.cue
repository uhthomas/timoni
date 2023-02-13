// Code generated by cue get go. DO NOT EDIT.

//cue:generate cue get go github.com/prometheus-operator/prometheus-operator/pkg/apis/monitoring/v1

package v1

import (
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"k8s.io/apimachinery/pkg/util/intstr"
	"k8s.io/api/core/v1"
)

#PodMonitorsKind:   "PodMonitor"
#PodMonitorName:    "podmonitors"
#PodMonitorKindKey: "podmonitor"

// PodMonitor defines monitoring for a set of pods.
#PodMonitor: {
	metav1.#TypeMeta
	metadata?: metav1.#ObjectMeta @go(ObjectMeta)

	// Specification of desired Pod selection for target discovery by Prometheus.
	spec: #PodMonitorSpec @go(Spec)
}

// PodMonitorSpec contains specification parameters for a PodMonitor.
// +k8s:openapi-gen=true
#PodMonitorSpec: {
	// The label to use to retrieve the job name from.
	jobLabel?: string @go(JobLabel)

	// PodTargetLabels transfers labels on the Kubernetes Pod onto the target.
	podTargetLabels?: [...string] @go(PodTargetLabels,[]string)

	// A list of endpoints allowed as part of this PodMonitor.
	podMetricsEndpoints: [...#PodMetricsEndpoint] @go(PodMetricsEndpoints,[]PodMetricsEndpoint)

	// Selector to select Pod objects.
	selector: metav1.#LabelSelector @go(Selector)

	// Selector to select which namespaces the Endpoints objects are discovered from.
	namespaceSelector?: #NamespaceSelector @go(NamespaceSelector)

	// SampleLimit defines per-scrape limit on number of scraped samples that will be accepted.
	sampleLimit?: uint64 @go(SampleLimit)

	// TargetLimit defines a limit on the number of scraped targets that will be accepted.
	targetLimit?: uint64 @go(TargetLimit)

	// Per-scrape limit on number of labels that will be accepted for a sample.
	// Only valid in Prometheus versions 2.27.0 and newer.
	labelLimit?: uint64 @go(LabelLimit)

	// Per-scrape limit on length of labels name that will be accepted for a sample.
	// Only valid in Prometheus versions 2.27.0 and newer.
	labelNameLengthLimit?: uint64 @go(LabelNameLengthLimit)

	// Per-scrape limit on length of labels value that will be accepted for a sample.
	// Only valid in Prometheus versions 2.27.0 and newer.
	labelValueLengthLimit?: uint64 @go(LabelValueLengthLimit)

	// Attaches node metadata to discovered targets.
	// Requires Prometheus v2.35.0 and above.
	attachMetadata?: null | #AttachMetadata @go(AttachMetadata,*AttachMetadata)
}

// PodMonitorList is a list of PodMonitors.
// +k8s:openapi-gen=true
#PodMonitorList: {
	metav1.#TypeMeta

	// Standard list metadata
	// More info: https://github.com/kubernetes/community/blob/master/contributors/devel/sig-architecture/api-conventions.md#metadata
	metadata?: metav1.#ListMeta @go(ListMeta)

	// List of PodMonitors
	items: [...null | #PodMonitor] @go(Items,[]*PodMonitor)
}

// PodMetricsEndpoint defines a scrapeable endpoint of a Kubernetes Pod serving Prometheus metrics.
// +k8s:openapi-gen=true
#PodMetricsEndpoint: {
	// Name of the pod port this endpoint refers to. Mutually exclusive with targetPort.
	port?: string @go(Port)

	// Deprecated: Use 'port' instead.
	targetPort?: null | intstr.#IntOrString @go(TargetPort,*intstr.IntOrString)

	// HTTP path to scrape for metrics.
	// If empty, Prometheus uses the default value (e.g. `/metrics`).
	path?: string @go(Path)

	// HTTP scheme to use for scraping.
	scheme?: string @go(Scheme)

	// Optional HTTP URL parameters
	params?: {[string]: [...string]} @go(Params,map[string][]string)

	// Interval at which metrics should be scraped
	// If not specified Prometheus' global scrape interval is used.
	interval?: #Duration @go(Interval)

	// Timeout after which the scrape is ended
	// If not specified, the Prometheus global scrape interval is used.
	scrapeTimeout?: #Duration @go(ScrapeTimeout)

	// TLS configuration to use when scraping the endpoint.
	tlsConfig?: null | #PodMetricsEndpointTLSConfig @go(TLSConfig,*PodMetricsEndpointTLSConfig)

	// Secret to mount to read bearer token for scraping targets. The secret
	// needs to be in the same namespace as the pod monitor and accessible by
	// the Prometheus Operator.
	bearerTokenSecret?: v1.#SecretKeySelector @go(BearerTokenSecret)

	// HonorLabels chooses the metric's labels on collisions with target labels.
	honorLabels?: bool @go(HonorLabels)

	// HonorTimestamps controls whether Prometheus respects the timestamps present in scraped data.
	honorTimestamps?: null | bool @go(HonorTimestamps,*bool)

	// BasicAuth allow an endpoint to authenticate over basic authentication.
	// More info: https://prometheus.io/docs/operating/configuration/#endpoint
	basicAuth?: null | #BasicAuth @go(BasicAuth,*BasicAuth)

	// OAuth2 for the URL. Only valid in Prometheus versions 2.27.0 and newer.
	oauth2?: null | #OAuth2 @go(OAuth2,*OAuth2)

	// Authorization section for this endpoint
	authorization?: null | #SafeAuthorization @go(Authorization,*SafeAuthorization)

	// MetricRelabelConfigs to apply to samples before ingestion.
	metricRelabelings?: [...null | #RelabelConfig] @go(MetricRelabelConfigs,[]*RelabelConfig)

	// RelabelConfigs to apply to samples before scraping.
	// Prometheus Operator automatically adds relabelings for a few standard Kubernetes fields.
	// The original scrape job's name is available via the `__tmp_prometheus_job_name` label.
	// More info: https://prometheus.io/docs/prometheus/latest/configuration/configuration/#relabel_config
	relabelings?: [...null | #RelabelConfig] @go(RelabelConfigs,[]*RelabelConfig)

	// ProxyURL eg http://proxyserver:2195 Directs scrapes to proxy through this endpoint.
	proxyUrl?: null | string @go(ProxyURL,*string)

	// FollowRedirects configures whether scrape requests follow HTTP 3xx redirects.
	followRedirects?: null | bool @go(FollowRedirects,*bool)

	// Whether to enable HTTP2.
	enableHttp2?: null | bool @go(EnableHttp2,*bool)

	// Drop pods that are not running. (Failed, Succeeded). Enabled by default.
	// More info: https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle/#pod-phase
	filterRunning?: null | bool @go(FilterRunning,*bool)
}

// PodMetricsEndpointTLSConfig specifies TLS configuration parameters.
// +k8s:openapi-gen=true
#PodMetricsEndpointTLSConfig: {
	#SafeTLSConfig
}
