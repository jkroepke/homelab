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

module "kubernetes-controller" {
  source = "./modules/kubernetes-controller"

  vpc_id             = module.vpc.id
  subnets            = module.vpc.private_subnets
  project_name       = local.project
  kubernetes_version = local.kubernetes_version
  route53_zone_id    = module.route53.id

  iam_instance_profile_name = module.ssm.iam_instance_profile_name
}
