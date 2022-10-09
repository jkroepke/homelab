resource "helm_release" "argocd" {
  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  namespace        = "argocd"
  version          = "5.5.16"
  create_namespace = true
  atomic           = true
  cleanup_on_fail  = true
  lint             = true
  timeout          = 300
  max_history      = 3

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

  set {
    name  = "configs.secret.extra.oidc\\.dex\\.clientSecret"
    value = data.azurerm_key_vault_secret.argocd-client-secret.value
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
