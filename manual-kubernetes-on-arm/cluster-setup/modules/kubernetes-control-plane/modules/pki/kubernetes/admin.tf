# Kubernetes API Server (tls/{admin.key,admin.crt})
resource "tls_private_key" "admin" {
  algorithm   = tls_private_key.kubernetes-ca.algorithm
  ecdsa_curve = tls_private_key.kubernetes-ca.ecdsa_curve
}

resource "tls_cert_request" "admin" {
  private_key_pem = tls_private_key.admin.private_key_pem

  subject {
    common_name  = "kubernetes-admin"
    organization = "system:masters"
  }
}

resource "tls_locally_signed_cert" "admin" {
  cert_request_pem = tls_cert_request.admin.cert_request_pem

  ca_private_key_pem = tls_private_key.kubernetes-ca.private_key_pem
  ca_cert_pem        = tls_self_signed_cert.kubernetes-ca.cert_pem

  validity_period_hours = 365

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "client_auth",
  ]
}
