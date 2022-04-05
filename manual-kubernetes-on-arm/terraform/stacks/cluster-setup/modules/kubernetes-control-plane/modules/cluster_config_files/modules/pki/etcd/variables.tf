variable "etcd_domain" {
  description = "Domain of etcd members"
}

variable "etcd_peer_names" {
  description = "List of etcd peers"
  type        = map(string)
}
