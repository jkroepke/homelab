locals {
  etcd_domain = "etcd.internal"
  etcd_peers  = { for i in range(1, var.controller_count + 1) : i => "etcd${i}.${local.etcd_domain}" }
  controllers = { for i in range(1, var.controller_count + 1) : i => values(var.vpc_private_subnets)[i - 1] }
}
