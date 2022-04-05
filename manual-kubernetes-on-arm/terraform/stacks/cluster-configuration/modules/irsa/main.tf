locals {
  namespace = "kube-system"
}

data "aws_region" "current" {}

resource "helm_release" "this" {
  repository = "https://jkroepke.github.io/helm-charts/"
  chart      = "amazon-eks-pod-identity-webhook"
  name       = "amazon-eks-pod-identity-webhook"

  version = "1.0.1"

  lint            = true
  atomic          = true
  cleanup_on_fail = true
  timeout         = 300

  values = [
    jsonencode({
      image = {
        registry = "registry.ipv6.docker.com"
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

