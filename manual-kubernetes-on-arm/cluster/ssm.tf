data "aws_ssm_parameter" "cluster_credentials" {
  for_each = toset([
    "host", "cluster_ca_certificate",
    "client_certificate", "client_key",
    "bootstrap_token_id", "bootstrap_token_secret"
  ])

  name  = "/${var.name}/kubernetes/cluster/credentials/${each.key}"
}
