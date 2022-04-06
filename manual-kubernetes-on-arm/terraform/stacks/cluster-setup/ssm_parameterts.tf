resource "aws_ssm_parameter" "cluster_credentials" {
  for_each = {
    kubernetes_api_server  = module.kubernetes-control-plane.kubernetes_api_server
    client_certificate     = module.kubernetes-control-plane.kubernetes_client_certificate
    client_key             = module.kubernetes-control-plane.kubernetes_client_key
    cluster_ca_certificate = module.kubernetes-control-plane.kubernetes_cluster_ca_certificate
    bootstrap_token_id     = module.kubernetes-control-plane.kubernetes_initial_bootstrap_token_id
    bootstrap_token_secret = module.kubernetes-control-plane.kubernetes_initial_bootstrap_token_secret
  }

  name  = "/${var.project_name}/kubernetes/cluster/credentials/${each.key}"
  type  = "SecureString"
  value = each.value

  tags = {
    system = "kubernetes"
  }
}

resource "aws_ssm_parameter" "cluster_config" {
  for_each = {
    kubernetes_version = var.kubernetes_version
    cluster_name       = local.cluster_name
    pod_cidr           = local.pod_cidr
    service_cidr       = local.service_cidr
    cluster_dns        = local.cluster_dns
    vpc_id             = module.vpc.id
  }

  name  = "/${var.project_name}/kubernetes/cluster/config/${each.key}"
  type  = "String"
  value = each.value

  tags = {
    system = "kubernetes"
  }
}
