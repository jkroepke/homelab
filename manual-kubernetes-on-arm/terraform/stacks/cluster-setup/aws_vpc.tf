module "vpc" {
  source = "./modules/vpc/"

  name     = var.project_name
  vpc_cidr = var.vpc_cidr

  private_subnet_cidr            = local.private_subnet_cidr
  public_subnet_cidr             = local.public_subnet_cidr
  kubernetes_service_subnet_cidr = local.service_cidr
  kubernetes_pod_subnet_cidr     = local.pod_cidr

  private_ipv6_net_id            = local.private_ipv6_net_id
  public_ipv6_net_id             = local.public_ipv6_net_id
  kubernetes_service_ipv6_net_id = local.service_ipv6_net_id
  kubernetes_pod_ipv6_net_id     = local.pod_ipv6_net_id
}
