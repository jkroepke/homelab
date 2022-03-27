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
  instance_type              = var.kubernetes_controller_instance_type
  kubernetes_api_hostname    = local.kubernetes_api_hostname
  kubernetes_oidc_issuer_url = local.kubernetes_oidc_issuer_url

  etcd_version       = var.etcd_version
  kubernetes_version = var.kubernetes_version

  service_cidr = local.service_cidr
  pod_cidr     = local.pod_cidr
  cluster_dns  = local.cluster_dns

  iam_additional_policy_arns = [module.aws-system-manager.iam_role_policy_arn]
}
