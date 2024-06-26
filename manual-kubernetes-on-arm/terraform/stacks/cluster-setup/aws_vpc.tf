module "vpc" {
  source = "./modules/vpc/"

  name     = var.project_name
  vpc_cidr = var.vpc_cidr

  private_subnet_cidr = local.private_subnet_cidr
  public_subnet_cidr  = local.public_subnet_cidr

  private_ipv6_net_id = local.private_ipv6_net_id
  public_ipv6_net_id  = local.public_ipv6_net_id

  tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "owned"
    "karpenter.sh/discovery"                      = local.cluster_name
  }
}
