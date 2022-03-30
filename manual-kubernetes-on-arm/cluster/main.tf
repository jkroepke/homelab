module "bootstrap" {
  source                 = "./modules/bootstrap"
  bootstrap_token_id     = data.aws_ssm_parameter.cluster_credentials["bootstrap_token_id"].value
  bootstrap_token_secret = data.aws_ssm_parameter.cluster_credentials["bootstrap_token_secret"].value
}

module "kube-proxy" {
  source = "./modules/kube-proxy"

  kubernetes_api_server = local.kubernetes_api_server
  kubernetes_version    = local.kubernetes_version
}

module "vpc-cni-k8s" {
  source = "./modules/vpc-cni-k8s"

  cluster_name = local.cluster_name

  depends_on = [module.bootstrap]
}

