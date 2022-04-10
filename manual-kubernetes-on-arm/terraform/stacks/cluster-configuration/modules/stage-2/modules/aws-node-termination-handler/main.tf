resource "helm_release" "this" {
  repository = "https://aws.github.io/eks-charts/"
  chart      = "aws-node-termination-handler"
  name       = "aws-node-termination-handler"
  version    = var.chart_version
  namespace  = "kube-system"

  max_history     = 3
  lint            = true
  wait            = true
  atomic          = true
  cleanup_on_fail = true
  timeout         = 300

  values = [
    jsonencode({
      emitKubernetesEvents         = true
      enableProbesServer           = true
      enablePrometheusServer       = true
      enableScheduledEventDraining = true
      enableRebalanceMonitoring    = true
      enableRebalanceDraining      = true
      excludeFromLoadBalancers     = true
      resources = {
        limits = {
          cpu    = "50m"
          memory = "50Mi"
        }
      }
      taintNode = true
    })
  ]
}
