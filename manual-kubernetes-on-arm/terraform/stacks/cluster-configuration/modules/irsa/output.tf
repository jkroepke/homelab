output "oidc_issuer" {
  value = aws_iam_openid_connect_provider.this.url
}

output "oidc_provider_arn" {
  value = aws_iam_openid_connect_provider.this.arn
}
