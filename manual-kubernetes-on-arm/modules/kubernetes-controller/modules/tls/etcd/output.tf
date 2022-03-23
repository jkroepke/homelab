output "ca" {
  value = tls_self_signed_cert.etcd-ca.cert_pem
}

output "client_key" {
  value = tls_private_key.client.private_key_pem
}

output "client_crt" {
  value = tls_locally_signed_cert.client.cert_pem
}

output "server_key" {
  value = tls_private_key.server.private_key_pem
}

output "server_crt" {
  value = tls_locally_signed_cert.server.cert_pem
}

output "peer_key" {
  value = tls_private_key.peer.private_key_pem
}

output "peer_crt" {
  value = tls_locally_signed_cert.peer.cert_pem
}

