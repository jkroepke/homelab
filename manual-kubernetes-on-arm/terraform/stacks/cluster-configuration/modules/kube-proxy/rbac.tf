resource "kubernetes_service_account" "this" {
  metadata {
    name      = "kube-proxy"
    namespace = local.namespace
  }
}

resource "kubernetes_role" "this" {
  metadata {
    name      = "kube-proxy"
    namespace = local.namespace
  }

  rule {
    api_groups = [""]
    resources  = ["configmaps"]
    verbs      = ["get"]
  }
}

resource "kubernetes_cluster_role_binding" "this" {
  metadata {
    name = "kube-proxy"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "system:node-proxier"
  }
  subject {
    kind      = "ServiceAccount"
    name      = "kube-proxy"
    namespace = local.namespace
  }
}
