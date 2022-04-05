locals {
  etcd_peer_names = { for availability_zone, properties in var.kubernetes_controllers : availability_zone => properties.etcd_peer_name }
}

data "aws_region" "current" {}
