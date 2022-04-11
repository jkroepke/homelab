resource "kubernetes_namespace" "this" {
  metadata {
    name = "kube-prometheus-stack"
  }
}

resource "helm_release" "this" {
  chart      = "kube-prometheus-stack"
  name       = "kube-prometheus-stack"
  repository = "https://prometheus-community.github.io/helm-charts"
  namespace  = kubernetes_namespace.this.metadata[0].name
  version    = var.chart_version

  max_history     = 3
  lint            = true
  wait            = true
  atomic          = true
  cleanup_on_fail = true
  timeout         = 300

  values = [file("${path.module}/values/kube-prometheus-stack.yaml")]
}
