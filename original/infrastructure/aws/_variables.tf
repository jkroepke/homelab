variable "name" {
  type = string
}

variable "vpc_cidr_block" {
  type = string
}

variable "availability_zones" {
  type = list(string)
}

variable "kubernetes_cluster_cidr_block" {
  type = string
}
