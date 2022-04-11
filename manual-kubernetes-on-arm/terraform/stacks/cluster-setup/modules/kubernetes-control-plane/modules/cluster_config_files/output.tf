output "files_pki_etcd" {
  value = local.files_pki_etcd
}

output "files_pki_kubernetes" {
  value = local.files_pki_kubernetes
}

output "files_controller_configs" {
  value = local.files_controller_configs
}

output "files_worker_configs" {
  value = local.files_worker_configs
}

output "kubernetes_client_certificate" {
  value = module.pki_kubernetes.admin_crt
}

output "kubernetes_client_key" {
  value = module.pki_kubernetes.admin_key
}

output "kubernetes_cluster_ca_certificate" {
  value = module.pki_kubernetes.ca_crt
}

output "kubernetes_cluster_front_proxy_ca_certificate" {
  value = module.pki_kubernetes.front_proxy_ca_crt
}

output "kubernetes_initial_bootstrap_token_id" {
  value = module.pki_kubernetes.bootstrap_token_id
}

output "kubernetes_initial_bootstrap_token_secret" {
  value = module.pki_kubernetes.bootstrap_token_secret
}

output "kubernetes_admin_config" {
  value = module.kubeconfig["admin"].rendered
}
