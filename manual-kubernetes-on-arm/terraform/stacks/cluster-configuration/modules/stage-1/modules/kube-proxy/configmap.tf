resource "kubernetes_config_map" "this" {
  metadata {
    name      = "kube-proxy"
    namespace = local.namespace
  }

  data = { for file in toset(fileset("${path.module}/resources", "*.conf")) : file => templatefile("${path.module}/resources/${file}", {
    kubernetes_api_server = var.kubernetes_api_server
  }) }
}

