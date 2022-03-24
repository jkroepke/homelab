variable "cluster_name" {
  type        = string
  description = "Cluster name"
}

variable "api_servers" {
  type        = list(string)
  description = "List of URLs used to reach kube-apiserver"
}

variable "etcd_servers" {
  type        = list(string)
  description = "List of URLs used to reach etcd servers."
}

variable "pod_cidr" {
  type        = string
  description = "CIDR IP range to assign Kubernetes pods"
  default     = "10.2.0.0/16"
}

variable "service_cidr" {
  type        = string
  description = <<EOD
CIDR IP range to assign Kubernetes services.
The 1st IP will be reserved for kube_apiserver, the 10th IP will be reserved for kube-dns.
EOD
  default     = "10.3.0.0/24"
}

variable "container_images" {
  type        = map(string)
  description = "Container images to use"

  default = {
    kube_apiserver          = "k8s.gcr.io/kube-apiserver:v1.23.4"
    kube_controller_manager = "k8s.gcr.io/kube-controller-manager:v1.23.4"
    kube_scheduler          = "k8s.gcr.io/kube-scheduler:v1.23.4"
    kube_proxy              = "k8s.gcr.io/kube-proxy:v1.23.4"
  }
}

# unofficial, temporary, may be removed without notice

variable "external_apiserver_port" {
  type        = number
  description = "External kube-apiserver port (e.g. 6443 to match internal kube-apiserver port)"
  default     = 6443
}

variable "cluster_domain_suffix" {
  type        = string
  description = "Queries for domains with the suffix will be answered by kube-dns"
  default     = "cluster.local"
}
