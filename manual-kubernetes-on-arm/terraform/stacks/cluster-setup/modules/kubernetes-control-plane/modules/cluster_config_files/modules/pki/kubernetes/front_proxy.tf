# https://kubernetes.io/docs/setup/best-practices/certificates/

# kube CA
resource "tls_private_key" "kubernetes_front_proxy_ca" {
  algorithm   = "ECDSA"
  ecdsa_curve = "P384"
}

resource "tls_self_signed_cert" "kubernetes_front_proxy_ca" {
  private_key_pem = tls_private_key.kubernetes_front_proxy_ca.private_key_pem

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

# Kubernetes API Server (tls/{front_proxy_client.key,front_proxy_client.crt})
resource "tls_private_key" "front_proxy_client" {
  algorithm   = tls_private_key.kubernetes_front_proxy_ca.algorithm
  ecdsa_curve = tls_private_key.kubernetes_front_proxy_ca.ecdsa_curve
}

resource "tls_cert_request" "front_proxy_client" {
  private_key_pem = tls_private_key.front_proxy_client.private_key_pem

  subject {
    common_name = "front-proxy-client"
  }
}

resource "tls_locally_signed_cert" "front_proxy_client" {
  cert_request_pem = tls_cert_request.front_proxy_client.cert_request_pem

  ca_private_key_pem = tls_private_key.kubernetes_front_proxy_ca.private_key_pem
  ca_cert_pem        = tls_self_signed_cert.kubernetes_front_proxy_ca.cert_pem

  validity_period_hours = 365

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "client_auth",
  ]
}
