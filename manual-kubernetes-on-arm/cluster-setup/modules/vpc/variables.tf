variable "name" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

variable "public_subnet_cidr" {
  type = string
}

variable "private_subnet_cidr" {
  type = string
}

variable "kubernetes_service_subnet_cidr" {
  type = string
}

variable "kubernetes_pod_subnet_cidr" {
  type = string
}

variable "public_ipv6_net_id" {
  type = string
}

variable "private_ipv6_net_id" {
  type = string
}

variable "kubernetes_service_ipv6_net_id" {
  type = string
}

variable "kubernetes_pod_ipv6_net_id" {
  type = string
}
