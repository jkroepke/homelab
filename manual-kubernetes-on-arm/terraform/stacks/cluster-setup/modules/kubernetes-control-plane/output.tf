output "kubernetes_api_server" {
  value = "https://${var.kubernetes_api_hostname}"
}

output "kubernetes_client_certificate" {
  value = module.cluster_config_files.kubernetes_client_certificate
}

output "kubernetes_client_key" {
  value = module.cluster_config_files.kubernetes_client_key
}

output "kubernetes_cluster_ca_certificate" {
  value = module.cluster_config_files.kubernetes_cluster_ca_certificate
}

output "kubernetes_initial_bootstrap_token_id" {
  value = module.cluster_config_files.kubernetes_initial_bootstrap_token_id
}

output "kubernetes_initial_bootstrap_token_secret" {
  value = module.cluster_config_files.kubernetes_initial_bootstrap_token_secret
}

output "kubernetes_admin_config" {
  value = module.cluster_config_files.kubernetes_admin_config
}
