module "k8s-controller" {
  source = "./modules/k8s-controller"

  vpc_id             = module.vpc.id
  subnets            = module.vpc.subnets
  project_name       = local.project
  kubernetes_version = "1.23"

  iam_instance_profile_name = module.ssm.iam_instance_profile_name
}
