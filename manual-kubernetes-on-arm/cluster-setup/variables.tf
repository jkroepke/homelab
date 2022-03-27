variable "name" {
  description = "Name of the project"
  default     = "jkr-manual-k8s"
  type        = string
}

variable "vpc_cidr" {
  description = "VPC CIDR of private IPv4 range"
  default     = "10.110.0.0/16"
  type        = string
}

variable "etcd_version" {
  description = "Version of etcd"
  # https://github.com/kubernetes/kubernetes/blob/02f7f0b66a8ae3f24ab1f9b072b8f9d1201a7ced/cmd/kubeadm/app/constants/constants.go#L304
  default     = "3.5.1"
  type        = string
}

variable "kubernetes_version" {
  description = "Version of kubernetes"
  default     = "1.23.5"
  type        = string
}

variable "kubernetes_controller_count" {
  description = "Number of Kubernetes Controller"
  default     = 3
  type        = number
}

variable "kubernetes_controller_instance_type" {
  description = "Instance type of Kubernetes Controller"
  default     = "t4g.small"
  type        = string
}

variable "parent_dns_zone" {
  description = "Parent DNS Zone"
  default     = "adorsys-sandbox.aws.adorsys.de"
  type        = string
}
