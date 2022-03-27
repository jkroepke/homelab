locals {
  cluster_dns         = cidrhost(local.service_cidr, 10)
  private_subnet_cidr = cidrsubnet(var.vpc_cidr, 4, 0)
  public_subnet_cidr  = cidrsubnet(var.vpc_cidr, 4, 1)
  service_cidr        = cidrsubnet(var.vpc_cidr, 4, 2)
  pod_cidr            = cidrsubnet(var.vpc_cidr, 4, 3)

  private_ipv6_net_id = 0
  public_ipv6_net_id  = 8
  service_ipv6_net_id = 16
  pod_ipv6_net_id     = 24

  kubernetes_api_hostname    = "api.${module.zone-delegation.name}"
  kubernetes_oidc_issuer_url = "https://auth.${module.zone-delegation.name}"
}
