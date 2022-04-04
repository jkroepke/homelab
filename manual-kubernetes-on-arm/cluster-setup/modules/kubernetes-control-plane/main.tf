locals {
  etcd_domain = "${var.cluster_name}.etcd.internal"
  controllers = {
    for index in range(0, var.controller_count) : keys(var.vpc_private_subnets)[index] => {
      name           = "${var.cluster_name}-controller-${keys(var.vpc_private_subnets)[index]}"
      subnet_id      = values(var.vpc_private_subnets)[index]
      etcd_peer_name = "etcd-${keys(var.vpc_private_subnets)[index]}.${local.etcd_domain}"
    }
  }
  etcd_peer_names = {for availability_zone, properties in local.controllers : availability_zone => properties.etcd_peer_name}
}

module "api_loadbalancer" {
  source = "./modules/loadbalancer"

  name            = "${var.cluster_name}-api"
  hostname        = var.kubernetes_api_hostname
  port            = 443
  route53_zone_id = var.route53_zone_id
  subnets         = var.vpc_public_subnets
  vpc_id          = var.vpc_id
}

module "iam" {
  source = "./modules/iam"

  ssm_policy_arn = var.ssm_policy_arn
  cluster_name   = var.cluster_name
}

module "kms" {
  source = "./modules/kms"

  name         = "${var.cluster_name}-secrets"
  iam_role_arn = module.iam.iam_role_arn
}

module "security_groups" {
  source = "./modules/security_groups"

  cluster_name = var.cluster_name
  vpc_id       = var.vpc_id
}
