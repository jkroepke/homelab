# etcd Server
resource "tls_private_key" "server" {
  for_each = var.etcd_peer_names

  algorithm   = tls_private_key.etcd-ca.algorithm
  ecdsa_curve = tls_private_key.etcd-ca.ecdsa_curve
}

resource "tls_cert_request" "server" {
  for_each = var.etcd_peer_names

  private_key_pem = tls_private_key.server[each.key].private_key_pem

  subject {
    common_name  = "etcd-server"
    organization = tls_self_signed_cert.etcd-ca.subject[0].organization
  }

  ip_addresses = [
    "127.0.0.1"
  ]

  dns_names = concat(["localhost", each.value])
}

resource "tls_locally_signed_cert" "server" {
  for_each = var.etcd_peer_names

  cert_request_pem = tls_cert_request.server[each.key].cert_request_pem

  ca_private_key_pem = tls_private_key.etcd-ca.private_key_pem
  ca_cert_pem        = tls_self_signed_cert.etcd-ca.cert_pem

  validity_period_hours = 8760

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
    # https://github.com/kopeio/etcd-manager/issues/305
    "client_auth",
  ]
}
