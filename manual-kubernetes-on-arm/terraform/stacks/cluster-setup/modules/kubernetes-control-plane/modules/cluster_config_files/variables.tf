variable "cluster_name" {
  type = string
}

variable "cluster_dns" {
  type = string
}

variable "kubernetes_api_hostname" {
  type = string
}

variable "kubernetes_controllers" {
  type = map(object({ availability_zone = string, etcd_peer_name = string, name = string, subnet_id = string }))
}

variable "kms_secret_encryption_arn" {
  type = string
}

variable "etcd_discovery_domain" {
  type = string
}

variable "etcd_version" {
  type = string
}

variable "kubernetes_version" {
  type = string
}

variable "kubernetes_pod_cidr" {
  type = string
}

variable "kubernetes_service_cidr" {
  type = string
}
