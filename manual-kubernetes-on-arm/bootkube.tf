/*
module "kubernetes-bootstrap" {
  source = "./modules/kubernetes-bootstrap"

  pod_cidr     = local.pod_cidr
  service_cidr = local.service_cidr

  api_servers  = []
  cluster_name = ""
  etcd_servers = []
}
*/

module "bootkube" {
  source = "./modules/bootkube"

  cluster_name = var.name

  vpc_id          = module.vpc.id
  vpc_subnets     = module.vpc.private_subnets
  route53_zone_id = module.zone-delegation.zone_id

  etcd_version       = var.etcd_version
  kubernetes_version = var.kubernetes_version
  controller_count   = var.kubernetes_controller_count

  service_cidr = var.kubernetes_service_cidr
  pod_cidr     = var.kubernetes_pod_cidr

  iam_additional_policy_arns = [module.aws-system-manager.iam_role_policy_arn]
}
