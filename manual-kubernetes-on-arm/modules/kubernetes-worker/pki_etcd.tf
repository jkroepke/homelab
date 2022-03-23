// See: https://kubernetes.io/docs/setup/best-practices/certificates/

resource "tls_private_key" "etcd-ca" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "tls_self_signed_cert" "etcd-ca" {
  key_algorithm   = tls_private_key.etcd-ca.algorithm
  private_key_pem = tls_private_key.etcd-ca.private_key_pem

  subject {
    common_name  = "${var.project_name} etcd CA"
    organization = var.project_name
  }

  validity_period_hours = 87600
  is_ca_certificate     = true

  allowed_uses = [
    "cert_signing",
    "crl_signing"
  ]
}
