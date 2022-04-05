output "ca_key" {
  value = tls_private_key.kubernetes-ca.private_key_pem
}

output "ca_crt" {
  value = tls_self_signed_cert.kubernetes-ca.cert_pem
}

output "apiserver_key" {
  value = tls_private_key.apiserver.private_key_pem
}

output "apiserver_crt" {
  value = tls_locally_signed_cert.apiserver.cert_pem
}

output "apiserver_kubelet_client_key" {
  value = tls_private_key.apiserver_kubelet_client.private_key_pem
}

output "apiserver_kubelet_client_crt" {
  value = tls_locally_signed_cert.apiserver_kubelet_client.cert_pem
}

output "front_proxy_ca_key" {
  value = tls_private_key.kubernetes_front_proxy_ca.private_key_pem
}

output "front_proxy_ca_crt" {
  value = tls_self_signed_cert.kubernetes_front_proxy_ca.cert_pem
}

output "front_proxy_client_key" {
  value = tls_private_key.apiserver.private_key_pem
}

output "front_proxy_client_crt" {
  value = tls_locally_signed_cert.apiserver.cert_pem
}

output "sa_key" {
  value = tls_private_key.sa.private_key_pem
}

output "sa_pub" {
  value = tls_private_key.sa.public_key_pem
}


output "admin_key" {
  value = tls_private_key.admin.private_key_pem
}

output "admin_crt" {
  value = tls_locally_signed_cert.admin.cert_pem
}

output "controller_manager_key" {
  value = tls_private_key.controller_manager.private_key_pem
}

output "controller_manager_crt" {
  value = tls_locally_signed_cert.controller_manager.cert_pem
}

output "scheduler_key" {
  value = tls_private_key.scheduler.private_key_pem
}

output "scheduler_crt" {
  value = tls_locally_signed_cert.scheduler.cert_pem
}

output "bootstrap_token_id" {
  value = random_password.bootstrap_token_id.result
}

output "bootstrap_token_secret" {
  value = random_password.bootstrap_token_secret.result
}
