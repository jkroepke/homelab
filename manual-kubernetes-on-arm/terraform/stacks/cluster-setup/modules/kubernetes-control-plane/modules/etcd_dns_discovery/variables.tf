variable "cluster_name" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "etcd_domain" {
  type = string
}

variable "etcd_peer_names" {
  type = list(string)
}
