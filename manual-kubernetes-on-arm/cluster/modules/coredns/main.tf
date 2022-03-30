resource "helm_release" "this" {
  chart      = "coredns"
  name       = "coredns"
  repository = "https://coredns.github.io/helm"
  # https://coredns.github.io/helm/index.yaml
  version    = "1.19.0"

  namespace = "kube-system"
  max_history = 10

  lint    = true
  wait    = true
  atomic  = true
  timeout = 300

  # https://github.com/hashicorp/terraform-provider-kubernetes/issues/723#issuecomment-1083297845
  values = [jsonencode({
    replicaCount = 3
    service = {
      clusterIP = var.cluster_dns
    }
  })]
}
