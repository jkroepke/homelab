locals {
  cluster_name          = data.aws_ssm_parameter.cluster_config["cluster_name"].value
  kubernetes_api_server = data.aws_ssm_parameter.cluster_credentials["kubernetes_api_server"].value
  kubernetes_version    = data.aws_ssm_parameter.cluster_config["kubernetes_version"].value
  service_cidr          = data.aws_ssm_parameter.cluster_config["service_cidr"].value
  pod_cidr              = data.aws_ssm_parameter.cluster_config["pod_cidr"].value
  cluster_dns           = data.aws_ssm_parameter.cluster_config["cluster_dns"].value
}

data "aws_ssm_parameter" "cluster_credentials" {
  for_each = toset([
    "kubernetes_api_server", "cluster_ca_certificate",
    "client_certificate", "client_key",
    "bootstrap_token_id", "bootstrap_token_secret"
  ])

  name  = "/${var.name}/kubernetes/cluster/credentials/${each.key}"
}

data "aws_ssm_parameter" "cluster_config" {
  for_each = toset([
    "kubernetes_version", "cluster_name", "cluster_dns",
    "pod_cidr", "service_cidr"
  ])

  name  = "/${var.name}/kubernetes/cluster/config/${each.key}"
}
