variable "name" {
  type = string
}

variable "iam_instance_role" {
  type = string
}

variable "cluster_name" {
  type = string
}

variable "cluster_dns" {
  type = string
}

variable "etcd_version" {
  type = string
}

variable "etcd_peer_name" {
  type = string
}

variable "etcd_discovery_domain" {
  type = string
}

variable "service_cidr" {
  type = string
}

variable "pod_cidr" {
  type = string
}

variable "kubernetes_api_hostname" {
  type = string
}

variable "kubernetes_version" {
  type = string
}

variable "kubernetes_oidc_issuer_url" {
  type = string
}

variable "kms_secret_encryption_arn" {
  type = string
}

variable "controller_count" {
  type = number
}

variable "additional_files" {
  type = map(object({ content = string, user = string, group = string, mode = string }))
}
