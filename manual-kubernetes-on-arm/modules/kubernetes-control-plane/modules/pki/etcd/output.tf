output "ca" {
  value = tls_self_signed_cert.etcd-ca.cert_pem
}

output "apiserver_etcd_client_key" {
  value = tls_private_key.apiserver_etcd_client.private_key_pem
}

output "apiserver_etcd_client_crt" {
  value = tls_locally_signed_cert.apiserver_etcd_client.cert_pem
}

output "healthcheck_client_key" {
  value = tls_private_key.healthcheck_client.private_key_pem
}

output "healthcheck_client_crt" {
  value = tls_locally_signed_cert.healthcheck_client.cert_pem
}

output "server_key" {
  value = tls_private_key.server.private_key_pem
}

output "server_crt" {
  value = tls_locally_signed_cert.server.cert_pem
}

output "peer_key" {
  value = { for name, cert in tls_private_key.peer : name => cert.private_key_pem }
}

output "peer_crt" {
  value = { for name, cert in tls_locally_signed_cert.peer : name => cert.cert_pem }
}

