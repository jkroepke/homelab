resource "kubernetes_secret" "this" {
  type = "bootstrap.kubernetes.io/token"

  metadata {
    # Name MUST be of form "bootstrap-token-<token_id>"
    name      = "bootstrap-token-${var.bootstrap_token_id}"
    namespace = "kube-system"
  }

  data = {
    token-id                       = var.bootstrap_token_id
    token-secret                   = var.bootstrap_token_secret
    usage-bootstrap-authentication = "true"
  }

  depends_on = [
    kubernetes_cluster_role_binding.auto-approve-csrs-for-group,
    kubernetes_cluster_role_binding.create-csrs-for-bootstrapping,
  ]
}
