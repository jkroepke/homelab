output "kubernetes_api_server" {
  value = "https://${var.kubernetes_api_hostname}:6443"
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
