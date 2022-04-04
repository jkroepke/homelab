# Kubernetes API Server (tls/{apiserver.key,apiserver.crt})
resource "tls_private_key" "apiserver" {
  algorithm   = tls_private_key.kubernetes-ca.algorithm
  ecdsa_curve = tls_private_key.kubernetes-ca.ecdsa_curve
}

resource "tls_cert_request" "apiserver" {
  private_key_pem = tls_private_key.apiserver.private_key_pem

  subject {
    common_name = "kube-apiserver"
  }

  dns_names = flatten([
    var.kubernetes_api_hostname,
    "kubernetes",
    "kubernetes.default",
    "kubernetes.default.svc",
    "kubernetes.default.svc.cluster.local",
  ])

  # Needed for in-cluster configs
  ip_addresses = [cidrhost(var.kubernetes_service_cidr, 1)]
}

resource "tls_locally_signed_cert" "apiserver" {
  cert_request_pem = tls_cert_request.apiserver.cert_request_pem

  ca_private_key_pem = tls_private_key.kubernetes-ca.private_key_pem
  ca_cert_pem        = tls_self_signed_cert.kubernetes-ca.cert_pem

  validity_period_hours = 365

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
  ]
}
