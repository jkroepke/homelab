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
  version    = var.chart_version

  max_history     = 3
  lint            = true
  wait            = true
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

      nodeSelector = {
        "node-role.kubernetes.io/master" = ""
      }

      namespaceSelector = {
        matchExpressions = [
          {
            key      = "kubernetes.io/metadata.name"
            operator = "NotIn"
            values   = ["kube-system"]
          }
        ]
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
