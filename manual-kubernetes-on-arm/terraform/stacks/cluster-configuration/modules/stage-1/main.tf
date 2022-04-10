locals {
  version_cloud_provider_aws       = "0.0.6"
  version_vpc_cni_k8s              = "1.1.14"
  version_kubelet_csr_approver     = "0.2.1"
  version_eks_pod_identity_webhook = "1.0.3"
  version_cert_manager             = "v1.7.2"

  # https://coredns.github.io/helm/index.yaml
  version_coredns   = "1.19.0"
  version_karpenter = "v0.8.1"
  version_calico    = "v3.21.4"
}

module "cloud-provider-aws" {
  source = "./modules/cloud-provider-aws"

  cluster_name  = var.cluster_name
  chart_version = local.version_cloud_provider_aws
}

module "kube-proxy" {
  source = "./modules/kube-proxy"

  kubernetes_api_server = var.kubernetes_api_server
  kubernetes_version    = var.kubernetes_version
}

module "vpc-cni-k8s" {
  source = "./modules/vpc-cni-k8s"

  kubernetes_api_server = var.kubernetes_api_server
  cluster_name          = var.cluster_name
  chart_version         = local.version_vpc_cni_k8s
}

module "kubelet-csr-approver" {
  source        = "./modules/kubelet-csr-approver"
  chart_version = local.version_kubelet_csr_approver
}

module "cert-manager" {
  source        = "./modules/cert-manager"
  chart_version = local.version_cert_manager
}

module "eks-pod-identity-webhook" {
  source        = "./modules/eks-pod-identity-webhook"
  chart_version = local.version_eks_pod_identity_webhook

  depends_on = [module.cert-manager]
}

module "calico" {
  source = "./modules/calico"

  chart_version = local.version_calico

  depends_on = [module.vpc-cni-k8s]
}

module "coredns" {
  source = "./modules/coredns"

  cluster_dns   = var.cluster_dns
  chart_version = local.version_coredns
}

module "karpenter" {
  source = "./modules/karpenter"

  kubernetes_api_server = var.kubernetes_api_server
  cluster_name          = var.cluster_name
  chart_version         = local.version_karpenter

  depends_on = [module.eks-pod-identity-webhook]
}
