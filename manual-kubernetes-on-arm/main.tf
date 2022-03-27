locals {
  project  = "jkr-manual-k8s"
  vpc_cidr = "10.110.0.0/16"

  # https://github.com/kubernetes/kubernetes/blob/02f7f0b66a8ae3f24ab1f9b072b8f9d1201a7ced/cmd/kubeadm/app/constants/constants.go#L304
  etcd_version       = "3.5.1"
  kubernetes_version = "1.23.5"

  cluster_dns         = cidrhost(local.service_cidr, 10)
  private_subnet_cidr = cidrsubnet(local.vpc_cidr, 4, 0)
  public_subnet_cidr  = cidrsubnet(local.vpc_cidr, 4, 1)
  service_cidr        = cidrsubnet(local.vpc_cidr, 4, 2)
  pod_cidr            = cidrsubnet(local.vpc_cidr, 4, 3)

  private_ipv6_net_id = 0
  public_ipv6_net_id  = 8
  service_ipv6_net_id = 16
  pod_ipv6_net_id     = 24

  kubernetes_api_hostname    = "api.${var.parent_dns_zone}"
  kubernetes_oidc_issuer_url = "https://auth.${var.parent_dns_zone}"
}

module "aws-system-manager" {
  source = "./modules/aws-system-manager"

  name = var.name
}

module "zone-delegation" {
  source = "./modules/route53-zone-delegation"

  name          = var.name
  root_dns_zone = var.parent_dns_zone
}

module "kubernetes-control-plane" {
  source = "./modules/kubernetes-control-plane"

  cluster_name = var.name

  vpc_id              = module.vpc.id
  vpc_private_subnets = module.vpc.private_subnets
  vpc_public_subnets  = module.vpc.public_subnets
  vpc_cidr_ipv4       = module.vpc.cidr_block
  vpc_cidr_ipv6       = module.vpc.ipv6_cidr_block
  route53_zone_id     = module.zone-delegation.zone_id

  controller_count           = var.kubernetes_controller_count
  kubernetes_api_hostname    = local.kubernetes_api_hostname
  kubernetes_oidc_issuer_url = local.kubernetes_oidc_issuer_url

  etcd_version       = var.etcd_version
  kubernetes_version = var.kubernetes_version

  service_cidr = local.service_cidr
  pod_cidr     = local.pod_cidr
  cluster_dns  = local.cluster_dns

  iam_additional_policy_arns = [module.aws-system-manager.iam_role_policy_arn]
}
