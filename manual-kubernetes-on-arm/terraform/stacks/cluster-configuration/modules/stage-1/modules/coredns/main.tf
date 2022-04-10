resource "helm_release" "this" {
  chart      = "coredns"
  name       = "coredns"
  repository = "https://coredns.github.io/helm"
  namespace  = "kube-system"
  version    = var.chart_version

  max_history     = 3
  lint            = true
  wait            = true
  atomic          = true
  cleanup_on_fail = true
  timeout         = 300

  # https://github.com/hashicorp/terraform-provider-kubernetes/issues/723#issuecomment-1083297845
  values = [jsonencode({
    replicaCount = 3
    service = {
      clusterIP = var.cluster_dns
    }
    tolerations = [
      {
        key    = "node-role.kubernetes.io/master"
        effect = "NoSchedule"
      }
    ]
  })]
}
