module "bootstrap" {
  source                 = "./modules/bootstrap"
  bootstrap_token_id     = data.aws_ssm_parameter.cluster_credentials["bootstrap_token_id"].value
  bootstrap_token_secret = data.aws_ssm_parameter.cluster_credentials["bootstrap_token_secret"].value
}

module "iam-oidc-provider" {
  source = "./modules/iam-oidc-provider"

  cluster_name          = local.cluster_name
  kubernetes_api_server = module.kubernetes-control-plane.kubernetes_api_server
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

module "coredns" {
  source = "./modules/coredns"

  cluster_dns = local.cluster_dns

  depends_on = [module.vpc-cni-k8s]
}

module "kubelet-csr-approver" {
  source = "./modules/kubelet-csr-approver"

  depends_on = [module.coredns]
}

module "cert-manager" {
  source = "./modules/cert-manager"

  depends_on = [module.coredns]
}

module "irsa" {
  source = "./modules/irsa"

  name                  = var.name
  kubernetes_api_server = local.kubernetes_api_server

  depends_on = [module.cert-manager]
}
