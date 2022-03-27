module "ignition" {
  for_each = local.controllers

  source = "./modules/ignition"

  index = each.key

  cluster_name = var.cluster_name

  kubernetes_version = var.kubernetes_version
  api_hostname       = var.kubernetes_api_hostname
  oidc_issuer_url    = var.kubernetes_oidc_issuer_url
  service_cidr       = var.service_cidr
  pod_cidr           = var.pod_cidr
  cluster_dns        = var.cluster_dns

  etcd_peer_name        = local.etcd_peers[each.key]
  etcd_discovery_domain = local.etcd_domain
  etcd_version          = var.etcd_version

  iam_instance_role         = module.iam.iam_role_arn
  kms_secret_encryption_arn = module.kms.arn

  additional_files = merge(
    local.files_pki_etcd[each.key],
    local.files_pki_kubernetes,
    local.files_kubernetes_configs
  )
}
