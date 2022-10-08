resource "helm_release" "argocd" {

  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  namespace        = "argocd"
  version          = "5.5.12"
  create_namespace = true
  atomic           = true
  cleanup_on_fail  = true
  lint             = true
  timeout          = 300

  values = [
    file("./values/argocd.yaml")
  ]
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
