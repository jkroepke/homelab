variable "cluster_name" {
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

variable "write_files" {
  type = map(object({content = string, owner = string, mode = string}))
}
