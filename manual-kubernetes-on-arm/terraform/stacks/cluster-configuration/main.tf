module "bootstrap" {
  source                 = "./modules/bootstrap"
  bootstrap_token_id     = data.aws_ssm_parameter.cluster_credentials["bootstrap_token_id"].value
  bootstrap_token_secret = data.aws_ssm_parameter.cluster_credentials["bootstrap_token_secret"].value
}

module "iam-oidc-provider" {
  source = "./modules/iam-oidc-provider"

  cluster_name          = local.cluster_name
  kubernetes_api_server = local.kubernetes_api_server
}

module "stage_1" {
  source                = "./modules/stage-1"
  cluster_dns           = local.cluster_dns
  cluster_name          = local.cluster_name
  kubernetes_api_server = local.kubernetes_api_server
  kubernetes_version    = local.kubernetes_version

  depends_on = [module.iam-oidc-provider]
}

module "stage_2" {
  source                = "./modules/stage-2"
  cluster_name          = local.cluster_name
  kubernetes_api_server = local.kubernetes_api_server

  depends_on = [module.stage_1]
}
