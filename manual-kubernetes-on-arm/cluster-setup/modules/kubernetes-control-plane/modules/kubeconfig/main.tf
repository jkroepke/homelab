locals {
  kubeconfig = {
    apiVersion  = "v1"
    kind        = "Config"
    preferences = {}
    clusters = [{
      name = "kubernetes"
      cluster = {
        server                     = var.kubernetes_server
        certificate-authority-data = var.kubernetes_ca
      }
    }],
    contexts = [{
      name = "${var.user}@kubernetes"
      context = {
        cluster = "kubernetes"
        user    = var.user
      }
    }]
    current-context = "${var.user}@kubernetes"
    users = [{
      name = var.user
      user = var.user_auth
    }]
  }
}
