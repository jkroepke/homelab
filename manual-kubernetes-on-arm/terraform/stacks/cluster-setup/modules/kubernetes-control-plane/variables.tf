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

variable "iam_role_policy_attachments" {
  type = list(string)
}

variable "instance_type" {
  type = string
}

variable "key_name" {
  type = string
}

variable "ami_image_id" {
  type = string
}

variable "kubernetes_pod_cidr" {
  type = string
}

variable "kubernetes_service_cidr" {
  type = string
}

variable "kubernetes_api_hostname" {
  type = string
}

variable "kubernetes_oidc_issuer" {
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

variable "vpc_security_group_ids" {
  type = list(string)
}
