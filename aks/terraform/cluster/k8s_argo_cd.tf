resource "helm_release" "argocd" {
  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  namespace        = kubernetes_namespace.argocd.metadata[0].name
  version          = "5.5.12"
  create_namespace = false
  atomic           = true
  cleanup_on_fail  = true
  lint             = true
  timeout          = 300

  values = [
    file("./values/argocd.yaml")
  ]

  set {
    name  = "repoServer.serviceAccount.annotations.azure\\.workload\\.identity/client-id"
    value = data.azurerm_user_assigned_identity.keyvault-access.client_id
  }

  set {
    name  = "repoServer.serviceAccount.labels.azure\\.workload\\.identity/use"
    value = "true"
  }
}

# https://github.com/argoproj/argo-helm/actions/runs/3211017996/jobs/5248886112
resource "kubernetes_labels" "repo-server-service-account" {
  api_version = "v1"
  kind        = "ServiceAccount"

  metadata {
    name      = "argocd-repo-server"
    namespace = helm_release.argocd.namespace
  }

  labels = {
    "azure.workload.identity/use" = "true"
  }
}

resource "helm_release" "argocd-apps" {
  name            = "argo-bootstrap-app"
  repository      = "https://argoproj.github.io/argo-helm"
  chart           = "argocd-apps"
  namespace       = "argocd"
  version         = "0.0.1"
  atomic          = true
  cleanup_on_fail = true
  lint            = true
  max_history     = 3
  timeout         = 300

  values = [
    file("./values/argocd-apps.yaml")
  ]

  depends_on = [
    helm_release.argocd
  ]
}
