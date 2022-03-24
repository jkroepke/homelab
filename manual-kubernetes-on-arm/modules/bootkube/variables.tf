variable "cluster_name" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "vpc_subnets" {
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

variable "route53_zone_id" {
  type = string
}
