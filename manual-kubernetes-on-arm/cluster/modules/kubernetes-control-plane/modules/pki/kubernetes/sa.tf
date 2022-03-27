# https://kubernetes.io/docs/setup/best-practices/certificates/

# kube CA
resource "tls_private_key" "sa" {
  algorithm   = "ECDSA"
  ecdsa_curve = "P384"
}
