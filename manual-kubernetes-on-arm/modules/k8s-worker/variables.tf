variable "project_name" {
  type = string
}

variable "subnets" {
  type = list(string)
}

variable "vpc_id" {
  type = string
}

variable "kubernetes_version" {
  type = string
}
