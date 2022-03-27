variable "cluster_name" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "vpc_public_subnets" {
  type = map(string)
}

variable "vpc_private_subnets" {
  type = map(string)
}

variable "kubernetes_version" {
  type = string
}

variable "controller_count" {
  type = number
}

variable "etcd_version" {
  type = string
}

variable "pod_cidr" {
  type = string
}

variable "service_cidr" {
  type = string
}

variable "iam_additional_policy_arns" {
  type = list(string)
}

variable "kubernetes_api_hostname" {
  type = string
}

variable "kubernetes_oidc_issuer_url" {
  type = string
}

variable "route53_zone_id" {
  type = string
}

variable "vpc_cidr_ipv4" {
  type = string
}

variable "vpc_cidr_ipv6" {
  type = string
}

variable "cluster_dns" {
  type = string
}
