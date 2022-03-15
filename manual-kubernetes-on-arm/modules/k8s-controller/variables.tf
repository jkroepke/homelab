variable "project_name" {
  type = string
}

variable "subnets" {
  type = map(string)
}

variable "vpc_id" {
  type = string
}

variable "kubernetes_version" {
  type = string
}

variable "iam_instance_profile_name" {
  type = string
}
