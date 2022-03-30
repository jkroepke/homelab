# https://github.com/aws/amazon-eks-pod-identity-webhook/blob/master/deploy/auth.yaml

resource "kubernetes_service_account" "this" {
  metadata {
    name      = "pod-identity-webhook"
    namespace = local.namespace
  }
}

resource "kubernetes_role" "this" {
  metadata {
    name      = "pod-identity-webhook"
    namespace = local.namespace
  }

  rule {
    api_groups = [""]
    resources  = ["secrets"]
    verbs      = ["create"]
  }
  rule {
    api_groups     = [""]
    resources      = ["secrets"]
    verbs          = ["get", "update", "patch"]
    resource_names = ["pod-identity-webhook"]
  }
}

resource "kubernetes_role_binding" "this" {
  metadata {
    name      = "pod-identity-webhook"
    namespace = local.namespace
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = kubernetes_role.this.metadata[0].name
  }
  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.this.metadata[0].name
    namespace = local.namespace
  }
}

resource "kubernetes_cluster_role" "this" {
  metadata {
    name = "pod-identity-webhook"
  }

  rule {
    api_groups = [""]
    resources  = ["serviceaccounts"]
    verbs      = ["get", "watch", "list"]
  }

  rule {
    api_groups = ["certificates.k8s.io"]
    resources  = ["certificatesigningrequests"]
    verbs      = ["create", "get", "list", "watch"]
  }
}

resource "kubernetes_cluster_role_binding" "this" {
  metadata {
    name = "pod-identity-webhook"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role.this.metadata[0].name
  }
  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.this.metadata[0].name
    namespace = local.namespace
  }
}
