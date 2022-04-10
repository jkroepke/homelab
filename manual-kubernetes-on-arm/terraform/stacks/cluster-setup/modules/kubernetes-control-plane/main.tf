locals {
  etcd_domain = "${var.cluster_name}.etcd.internal"
  kubernetes_controllers = { for index in range(0, var.controller_count) : index => {
    availability_zone = keys(var.vpc_private_subnets)[index]
    etcd_peer_name    = "etcd-${index}.${local.etcd_domain}"
    name              = "${var.cluster_name}-controller${index}"
    subnet_id         = values(var.vpc_private_subnets)[index]
  } }
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

module "kms_etcd_secrets" {
  source = "../../../../modules/kms"

  name         = "${var.cluster_name}-etcd-secrets"
  iam_role_arn = module.iam-instance-profile.iam_role_arn
}

module "etcd_dns_discovery_zone" {
  source = "./modules/etcd_dns_discovery"

  cluster_name = var.cluster_name
  vpc_id       = var.vpc_id

  etcd_domain     = local.etcd_domain
  etcd_peer_names = [for properties in values(local.kubernetes_controllers) : properties.etcd_peer_name]
}

module "cluster_config_files" {
  source = "./modules/cluster_config_files"

  kubernetes_cluster_dns    = var.cluster_dns
  cluster_name              = var.cluster_name
  etcd_discovery_domain     = local.etcd_domain
  etcd_version              = var.etcd_version
  kms_secret_encryption_arn = module.kms_etcd_secrets.arn
  kubernetes_api_hostname   = var.kubernetes_api_hostname
  kubernetes_oidc_issuer    = var.kubernetes_oidc_issuer
  kubernetes_controllers    = local.kubernetes_controllers
  kubernetes_pod_cidr       = var.kubernetes_pod_cidr
  kubernetes_service_cidr   = var.kubernetes_service_cidr
  kubernetes_version        = var.kubernetes_version
}

module "controller_user_data" {
  source = "./modules/user_data"

  for_each = local.kubernetes_controllers

  name               = each.value.name
  kubernetes_version = var.kubernetes_version
  files = merge(
    module.cluster_config_files.files_pki_etcd[each.key],
    module.cluster_config_files.files_pki_kubernetes,
    module.cluster_config_files.files_controller_configs[each.key],
  )
}

module "controller_asg_handler" {
  source = "./modules/controller_asg_handler"

  name                  = "${var.cluster_name}-asg-handler"
  route53_zone_id       = module.etcd_dns_discovery_zone.zone_id
  autoscale_group_names = [for properties in values(local.kubernetes_controllers) : properties.name]
}

module "controller" {
  for_each = local.kubernetes_controllers

  source = "./modules/controller"

  index = each.key

  name                      = each.value.name
  ami_image_id              = var.ami_image_id
  availability_zone         = each.value.availability_zone
  cluster_name              = var.cluster_name
  etcd_peer_name            = each.value.etcd_peer_name
  etcd_route53_zone_id      = module.etcd_dns_discovery_zone.zone_id
  iam_instance_profile_name = module.iam-instance-profile.iam_instance_profile_name
  instance_type             = var.instance_type
  key_name                  = var.key_name
  lb_target_group_arn       = module.api_loadbalancer.lb_target_group_arn
  subnet_id                 = each.value.subnet_id
  user_data                 = module.controller_user_data[each.key].rendered
  vpc_security_group_ids    = var.vpc_security_group_ids

  depends_on = [module.controller_asg_handler]
}
