locals {
  # Kubernetes Aggregation TLS assets map
  aggregation_tls = {
    "tls/k8s/aggregation-ca.crt"     = tls_self_signed_cert.aggregation-ca.cert_pem,
    "tls/k8s/aggregation-client.crt" = tls_locally_signed_cert.aggregation-client.cert_pem,
    "tls/k8s/aggregation-client.key" = tls_private_key.aggregation-client.private_key_pem,
  }
}

# Kubernetes Aggregation CA (i.e. front-proxy-ca)
# Files: tls/{aggregation-ca.crt,aggregation-ca.key}

resource "tls_private_key" "aggregation-ca" {
  algorithm = "RSA"
  rsa_bits  = "2048"
}

resource "tls_self_signed_cert" "aggregation-ca" {
  key_algorithm   = tls_private_key.aggregation-ca.algorithm
  private_key_pem = tls_private_key.aggregation-ca.private_key_pem

  subject {
    common_name = "kubernetes-front-proxy-ca"
  }

  is_ca_certificate     = true
  validity_period_hours = 8760

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "cert_signing",
  ]
}

# Kubernetes apiserver (i.e. front-proxy-client)
# Files: tls/{aggregation-client.crt,aggregation-client.key}

resource "tls_private_key" "aggregation-client" {
  algorithm = "RSA"
  rsa_bits  = "2048"
}

resource "tls_cert_request" "aggregation-client" {
  key_algorithm   = tls_private_key.aggregation-client.algorithm
  private_key_pem = tls_private_key.aggregation-client.private_key_pem

  subject {
    common_name = "kube-apiserver"
  }
}

resource "tls_locally_signed_cert" "aggregation-client" {
  cert_request_pem = tls_cert_request.aggregation-client.cert_request_pem

  ca_key_algorithm   = tls_self_signed_cert.aggregation-ca.key_algorithm
  ca_private_key_pem = tls_private_key.aggregation-ca.private_key_pem
  ca_cert_pem        = tls_self_signed_cert.aggregation-ca.cert_pem

  validity_period_hours = 8760

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "client_auth",
  ]
}

