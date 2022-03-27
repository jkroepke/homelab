variable "cluster_name" {
  type = string
}

variable "service_cidr" {
  type = string
}

variable "etcd_discovery_domain" {
  type = string
}

variable "etcd_peer_name" {
  type = string
}

variable "etcd_version" {
  type = string
}

variable "kubernetes_version" {
  type = string
}

variable "oidc_issuer_url" {
  type = string
}

variable "kms_secret_encryption_arn" {
  type = string
}
