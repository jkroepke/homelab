locals {
  name      = "amazon-eks-pod-identity-webhook"
  namespace = "kube-system"
}

data "aws_region" "current" {}

resource "helm_release" "this" {
  repository = "https://jkroepke.github.io/helm-charts/"
  chart      = local.name
  name       = local.name
  namespace  = local.namespace
  version    = "1.0.3"

  lint            = true
  atomic          = true
  cleanup_on_fail = true
  timeout         = 300

  values = [
    jsonencode({
      config = {
        defaultAwsRegion = data.aws_region.current.name
      }

      hostNetwork = true

      image = {
        registry = "registry.ipv6.docker.com"
      }

      pki = {
        certManager = {
          enabled = false
        }
        caBundle = tls_self_signed_cert.ca.cert_pem
        cert     = tls_locally_signed_cert.server.cert_pem
        key      = tls_private_key.server.private_key_pem
      }

      nodeSelector = {
        "node-role.kubernetes.io/master" = ""
      }

      replicaCount = 3

      tolerations = [
        {
          key    = "node.cloudprovider.kubernetes.io/uninitialized"
          value  = "true"
          effect = "NoSchedule"
        },
        {
          key    = "node-role.kubernetes.io/master"
          effect = "NoSchedule"
        }
      ]
    })
  ]
}
