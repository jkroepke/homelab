variable "cluster_name" {
  type = string
}

variable "iam_role_policy_attachments" {
  type = list(string)
}

variable "vpc_security_group_ids" {
  type = list(string)
}

variable "key_name" {
  type = string
}

variable "ami_image_id" {
  type = string
}

variable "kubernetes_version" {
  type = string
}

variable "files" {
  type = map(object({ content = string, user = string, group = string, mode = string }))
}

variable "volume_size" {
  type = number
}
