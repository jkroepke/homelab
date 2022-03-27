# Kubernetes API Server (tls/{controller_manager.key,controller_manager.crt})
resource "tls_private_key" "controller_manager" {
  algorithm   = tls_private_key.kubernetes-ca.algorithm
  ecdsa_curve = tls_private_key.kubernetes-ca.ecdsa_curve
}

resource "tls_cert_request" "controller_manager" {
  key_algorithm   = tls_private_key.controller_manager.algorithm
  private_key_pem = tls_private_key.controller_manager.private_key_pem

  subject {
    common_name = "system:kube-controller-manager"
  }
}

resource "tls_locally_signed_cert" "controller_manager" {
  cert_request_pem = tls_cert_request.controller_manager.cert_request_pem

  ca_key_algorithm   = tls_self_signed_cert.kubernetes-ca.key_algorithm
  ca_private_key_pem = tls_private_key.kubernetes-ca.private_key_pem
  ca_cert_pem        = tls_self_signed_cert.kubernetes-ca.cert_pem

  validity_period_hours = 365

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "client_auth",
  ]
}
