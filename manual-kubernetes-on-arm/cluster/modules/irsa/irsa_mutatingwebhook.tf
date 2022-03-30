resource "kubernetes_mutating_webhook_configuration" "this" {
  metadata {}
  webhook {
    name = ""
    client_config {}
    rule {
      api_groups   = []
      api_versions = []
      operations   = []
      resources    = []
    }
  }
}
