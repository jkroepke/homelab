variable "project" {
  default = "jok-fargate-demo"
}

variable "cidr_block" {
  description = "VPC cidr_block"
  default     = "10.49.0.0/16"
}

variable "eks_cluster_version" {
  default = "1.23"
}
