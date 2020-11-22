#------------------------------------------------------------------------------#
# Bootstrap token for kubeadm
#------------------------------------------------------------------------------#

# Generate bootstrap token
# See https://kubernetes.io/docs/reference/access-authn-authz/bootstrap-tokens/
resource "random_string" "token_id" {
  length  = 6
  special = false
  upper   = false
}

resource "random_string" "token_secret" {
  length  = 16
  special = false
  upper   = false
}

resource "random_string" "encryption_key" {
  length  = 64
  special = false
  upper   = false
}

locals {
  encryption_key  = sha256(random_string.encryption_key.result)
  bootstrap_token = "${random_string.token_id.result}.${random_string.token_secret.result}"
}
