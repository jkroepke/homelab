module "ignition" {
  source = "./modules/ignition"

  name         = var.name
  cluster_name = var.cluster_name

  kubernetes_version         = var.kubernetes_version
  kubernetes_api_hostname    = var.kubernetes_api_hostname
  kubernetes_oidc_issuer_url = var.kubernetes_oidc_issuer_url
  service_cidr               = var.service_cidr
  pod_cidr                   = var.pod_cidr
  cluster_dns                = var.cluster_dns

  etcd_peer_name        = var.etcd_peer_name
  etcd_discovery_domain = var.etcd_discovery_domain
  etcd_version          = var.etcd_version

  iam_instance_role         = var.iam_instance_role_arn
  kms_secret_encryption_arn = var.kms_secret_encryption_arn
  controller_count          = var.controller_count

  additional_files = var.additional_files
}
