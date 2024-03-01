resource "helm_release" "argocd" {
  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  namespace        = "argocd"
  version          = "5.55.0"
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

  set_sensitive {
    name  = "configs.secret.extra.oidc\\.dex\\.clientSecret"
    value = data.azurerm_key_vault_secret.aks-credentials["dexidp-argocd-secret"].value
  }

  set_sensitive {
    name  = "notifications.secret.items.github-client-secret"
    value = base64decode(data.azurerm_key_vault_secret.aks-credentials["argocd-notifications-github-app-private-key"].value)
    type  = "string"
  }
}

resource "helm_release" "argocd-apps" {
  name            = "argo-bootstrap-app"
  repository      = "https://argoproj.github.io/argo-helm"
  chart           = "argocd-apps"
  namespace       = "argocd"
  version         = "0.0.9"
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
