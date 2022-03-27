# Generate a cryptographically random token id (public)
resource "random_password" "bootstrap_token_id" {
  length  = 6
  upper   = false
  special = false
}

# Generate a cryptographically random token secret
resource "random_password" "bootstrap_token_secret" {
  length  = 16
  upper   = false
  special = false
}
