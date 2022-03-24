module "control-plane" {
  source = "./modules/control-plane"

  cluster_name               = var.cluster_name
  controller_count           = var.controller_count
  etcd_version               = var.etcd_version
  iam_additional_policy_arns = var.iam_additional_policy_arns
  kubernetes_version         = var.kubernetes_version
  pod_cidr                   = var.pod_cidr
  service_cidr               = var.service_cidr
  vpc_id                     = var.vpc_id
  vpc_subnets                = var.vpc_subnets
}


