variable "etcd_domain" {
  description = "Domain of etcd members"
}

variable "etcd_peers" {
  description = "List of etcd peers"
  type        = map(string)
}
