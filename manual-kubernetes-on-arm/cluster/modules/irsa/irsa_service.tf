resource "kubernetes_service" "this" {
  metadata {
    name      = "pod-identity-webhook"
    namespace = local.namespace
    annotations = {
      "prometheus.io/port"   = "443"
      "prometheus.io/scheme" = "https"
      "prometheus.io/scrape" = "true"
    }
  }
  spec {
    port {
      port        = 443
      target_port = 443
    }
    selector = {
      app = "pod-identity-webhook"
    }
  }
}
