locals {
  cluster_name = data.aws_ssm_parameter.cluster_config["cluster_name"].value
}

data "aws_ssm_parameter" "cluster_credentials" {
  for_each = toset([
    "host", "cluster_ca_certificate",
    "client_certificate", "client_key",
    "bootstrap_token_id", "bootstrap_token_secret"
  ])

  name  = "/${var.name}/kubernetes/cluster/credentials/${each.key}"
}

data "aws_ssm_parameter" "cluster_config" {
  for_each = toset([
    "version", "cluster_name", "cluster_dns",
    "pod_cidr", "service_cidr"
  ])

  name  = "/${var.name}/kubernetes/cluster/config/${each.key}"
}
