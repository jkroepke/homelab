resource "helm_release" "this" {
  repository = "https://charts.deliveryhero.io/"
  chart      = "node-problem-detector"
  name       = "node-problem-detector"
  version    = "2.2.0"
  namespace  = "kube-system"

  max_history     = 3
  lint            = true
  wait            = true
  atomic          = true
  cleanup_on_fail = true
  timeout         = 300

  values = [
    jsonencode({
      image = {
        # https://github.com/kubernetes/node-problem-detector/issues/586
        repository = "kelvie/node-problem-detector"
        tag        = "v0.8.10-5-gb0fa610"
      }

      metrics = {
        enabled = true
      }
      resources = {
        limits = {
          cpu    = "50m"
          memory = "50Mi"
        }
      }
    })
  ]
}
