resource "kubernetes_namespace" "this" {
  metadata {
    name = "cert-manager"
  }
}

resource "helm_release" "this" {
  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  name       = "cert-manager"
  version    = "v1.7.2"

  namespace = kubernetes_namespace.this.metadata[0].name
  max_history = 10

  lint    = true
  wait    = true
  atomic  = true
  timeout = 300

  values = [
    jsonencode({
      installCRDs = true
    })
  ]
}
