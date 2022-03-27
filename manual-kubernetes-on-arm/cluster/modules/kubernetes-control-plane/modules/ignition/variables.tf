variable "index" {
  type = number
}

variable "iam_instance_role" {
  type = string
}

variable "cluster_name" {
  type = string
}

variable "cluster_dns" {
  type = string
}

variable "pod_cidr" {
  type = string
}

variable "kubernetes_version" {
  type = string
}

variable "etcd_version" {
  type = string
}

variable "etcd_peer_name" {
  type = string
}

variable "files" {
  type = map(object({ content = string, user = string, group = string, mode = string }))
}
