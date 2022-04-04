# https://kubernetes.io/docs/setup/best-practices/certificates/

# kube CA
resource "tls_private_key" "kubernetes-ca" {
  algorithm   = "ECDSA"
  ecdsa_curve = "P384"
}

resource "tls_self_signed_cert" "kubernetes-ca" {
  private_key_pem = tls_private_key.kubernetes-ca.private_key_pem

  subject {
    common_name = "kubernetes-ca"
  }

  is_ca_certificate     = true
  validity_period_hours = 8760

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "cert_signing",
  ]
}

