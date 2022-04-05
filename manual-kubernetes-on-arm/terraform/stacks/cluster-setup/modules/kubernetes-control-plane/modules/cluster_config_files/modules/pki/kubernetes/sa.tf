# https://kubernetes.io/docs/setup/best-practices/certificates/

# Sign Key for Kubernetes Service Accounts
# This needs to be a RSA key, since AWS does not support Elliptic Curve JWTs in IAM/OIDC
# https://forums.aws.amazon.com/thread.jspa?threadID=305413
resource "tls_private_key" "sa" {
  algorithm = "RSA"
  rsa_bits  = "4096"
}
