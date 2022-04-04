module "controller_scale_handler" {
  source = "./modules/controller_scale_handler"

  name                  = "${var.cluster_name}-asg-handler"
  route53_zone_id       = module.etcd_dns_discovery.zone_id
  autoscale_group_names = [for properties in values(local.controllers): properties.name]
}

module "controller" {
  for_each = local.controllers

  source = "./modules/controller"

  name = each.value.name

  vpc_id                = var.vpc_id
  subnet_id             = each.value.subnet_id
  availability_zone     = each.key
  route53_zone_id       = var.route53_zone_id
  lb_target_group_arn   = module.api_loadbalancer.lb_target_group_arn
  vpc_security_group_id = module.security_groups.controller_security_group_id

  cluster_name               = var.cluster_name
  kubernetes_version         = var.kubernetes_version
  kubernetes_api_hostname    = var.kubernetes_api_hostname
  kubernetes_oidc_issuer_url = var.kubernetes_oidc_issuer_url

  service_cidr = var.service_cidr
  pod_cidr     = var.pod_cidr
  cluster_dns  = var.cluster_dns

  etcd_version          = var.etcd_version
  etcd_peer_name        = each.value.etcd_peer_name
  etcd_discovery_domain = local.etcd_domain
  etcd_route53_zone_id  = module.etcd_dns_discovery.zone_id

  iam_instance_profile_name = module.iam.iam_instance_profile_name
  iam_instance_role_arn     = module.iam.iam_role_arn
  kms_secret_encryption_arn = module.kms.arn
  controller_count          = var.controller_count

  additional_files = merge(
    local.files_pki_etcd[each.key],
    local.files_pki_kubernetes,
    local.files_kubernetes_configs
  )

  depends_on = [module.controller_scale_handler]
}
