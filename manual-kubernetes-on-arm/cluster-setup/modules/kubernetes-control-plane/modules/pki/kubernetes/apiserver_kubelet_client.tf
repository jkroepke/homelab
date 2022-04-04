resource "tls_private_key" "apiserver_kubelet_client" {
  algorithm   = tls_private_key.kubernetes-ca.algorithm
  ecdsa_curve = tls_private_key.kubernetes-ca.ecdsa_curve
}

resource "tls_cert_request" "apiserver_kubelet_client" {
  private_key_pem = tls_private_key.apiserver_kubelet_client.private_key_pem

  subject {
    common_name  = "kube-apiserver-kubelet-client"
    organization = "system:masters"
  }
}

resource "tls_locally_signed_cert" "apiserver_kubelet_client" {
  cert_request_pem = tls_cert_request.apiserver_kubelet_client.cert_request_pem

  ca_private_key_pem = tls_private_key.kubernetes-ca.private_key_pem
  ca_cert_pem        = tls_self_signed_cert.kubernetes-ca.cert_pem

  validity_period_hours = 365

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "client_auth",
  ]
}
