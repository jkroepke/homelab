module "etcd_dns_discovery" {
  source = "./modules/etcd_dns_discovery"

  cluster_name = var.cluster_name
  vpc_id       = var.vpc_id

  etcd_domain     = local.etcd_domain
  etcd_peer_names = values(local.etcd_peer_names)
}
