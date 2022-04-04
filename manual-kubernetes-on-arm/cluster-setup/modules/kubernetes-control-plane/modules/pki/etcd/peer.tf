# etcd Peer
resource "tls_private_key" "peer" {
  for_each = var.etcd_peer_names

  algorithm   = tls_private_key.etcd-ca.algorithm
  ecdsa_curve = tls_private_key.etcd-ca.ecdsa_curve
}

resource "tls_cert_request" "peer" {
  for_each = var.etcd_peer_names

  private_key_pem = tls_private_key.peer[each.key].private_key_pem

  subject {
    common_name  = "etcd-peer"
    organization = tls_self_signed_cert.etcd-ca.subject[0].organization
  }

  dns_names = [each.value]
}

resource "tls_locally_signed_cert" "peer" {
  for_each = var.etcd_peer_names

  cert_request_pem = tls_cert_request.peer[each.key].cert_request_pem

  ca_private_key_pem = tls_private_key.etcd-ca.private_key_pem
  ca_cert_pem        = tls_self_signed_cert.etcd-ca.cert_pem

  validity_period_hours = 8760

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
    "client_auth",
  ]
}
