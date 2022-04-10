resource "helm_release" "this" {
  repository = "https://kubernetes-sigs.github.io/metrics-server/"
  chart      = "metrics-server"
  name       = "metrics-server"
  namespace  = "kube-system"
  version    = var.chart_version

  max_history     = 3
  lint            = true
  wait            = true
  atomic          = true
  cleanup_on_fail = true
  timeout         = 300

  values = [jsonencode({
    tolerations = [
      {
        key    = "node-role.kubernetes.io/master"
        effect = "NoSchedule"
      }
    ]
  })]
}

