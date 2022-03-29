module "bootstrap" {
  source                 = "./modules/bootstrap"
  bootstrap_token_id     = data.aws_ssm_parameter.cluster_credentials["bootstrap_token_id"].value
  bootstrap_token_secret = data.aws_ssm_parameter.cluster_credentials["bootstrap_token_secret"].value
}

module "vpc-cni-k8s" {
  source = "./modules/vpc-cni-k8s"

  cluster_name = local.cluster_name

  depends_on = [module.bootstrap]
}

