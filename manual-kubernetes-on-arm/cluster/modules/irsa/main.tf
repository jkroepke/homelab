locals {
  namespace = "kube-system"
}

data "tls_certificate" "this" {
  url          = var.kubernetes_api_server
  verify_chain = false
}

resource "aws_iam_openid_connect_provider" "this" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.this.certificates[0].sha1_fingerprint]
  url             = var.kubernetes_api_server

  tags = {
    Name = "${var.name}-kubernetes"
  }
}

data "aws_region" "current" {}

resource "helm_release" "this" {
  repository = "https://jkroepke.github.io/helm-charts/"
  chart      = "amazon-eks-pod-identity-webhook"
  name       = "amazon-eks-pod-identity-webhook"

  version = "0.1.0"

  lint            = true
  atomic          = true
  cleanup_on_fail = true
  timeout         = 300

  values = [
    jsonencode({
      image = {
        repository = "registry.ipv6.docker.com/amazon/amazon-eks-pod-identity-webhook"
      }

      config = {
        defaultAwsRegion = data.aws_region.current.name
      }
    })
  ]
}


module "tests" {
  source = "./modules/test/"

  name              = "irsa-test"
  oidc_provider_arn = aws_iam_openid_connect_provider.this.arn
  issuer            = aws_iam_openid_connect_provider.this.url

  depends_on = [helm_release.this]
}

