resource "tls_private_key" "healthcheck_client" {
  algorithm   = tls_private_key.etcd-ca.algorithm
  ecdsa_curve = tls_private_key.etcd-ca.ecdsa_curve
}

resource "tls_cert_request" "healthcheck_client" {
  key_algorithm   = tls_private_key.healthcheck_client.algorithm
  private_key_pem = tls_private_key.healthcheck_client.private_key_pem

  subject {
    common_name  = "kube-etcd-healthcheck-client"
    organization = tls_self_signed_cert.etcd-ca.subject[0].organization
  }

  ip_addresses = [
    "127.0.0.1",
  ]

  dns_names = concat(["localhost"])
}

resource "tls_locally_signed_cert" "healthcheck_client" {
  cert_request_pem = tls_cert_request.healthcheck_client.cert_request_pem

  ca_key_algorithm   = tls_self_signed_cert.etcd-ca.key_algorithm
  ca_private_key_pem = tls_private_key.etcd-ca.private_key_pem
  ca_cert_pem        = tls_self_signed_cert.etcd-ca.cert_pem

  validity_period_hours = 8760

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "client_auth",
  ]
}
