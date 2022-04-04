variable "name" {
  type = string
}

variable "iam_instance_role_arn" {
  type = string
}

variable "iam_instance_profile_name" {
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

variable "etcd_route53_zone_id" {
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

variable "additional_files" {
  type = map(object({ content = string, user = string, group = string, mode = string }))
}

variable "vpc_id" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "route53_zone_id" {
  type = string
}

variable "availability_zone" {
  type = string
}

variable "lb_target_group_arn" {
  type = string
}

variable "vpc_security_group_id" {
  type = string
}

variable "controller_count" {
  type = number
}
