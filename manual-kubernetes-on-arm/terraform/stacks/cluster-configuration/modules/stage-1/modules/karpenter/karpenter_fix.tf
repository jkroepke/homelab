resource "kubernetes_cluster_role" "karpenter_fix" {
  metadata {
    name = "karpenter_fix"
  }

  rule {
    api_groups     = ["admissionregistration.k8s.io"]
    resources      = ["validatingwebhookconfigurations"]
    verbs          = ["delete"]
    resource_names = ["validation.webhook.provisioners.karpenter.sh", "validation.webhook.config.karpenter.sh"]
  }

  rule {
    api_groups     = ["admissionregistration.k8s.io"]
    resources      = ["mutatingwebhookconfigurations"]
    verbs          = ["delete"]
    resource_names = ["defaulting.webhook.provisioners.karpenter.sh"]
  }

  rule {
    api_groups     = [""]
    resources      = ["namespaces/finalizers"]
    verbs          = ["update"]
    resource_names = [kubernetes_namespace.this.metadata[0].name]
  }

  rule {
    api_groups = ["apps"]
    resources  = ["statefulsets/finalizers", "replicasets/finalizers"]
    verbs      = ["update"]
  }

  rule {
    api_groups = ["batch"]
    resources  = ["jobs/finalizers"]
    verbs      = ["update"]
  }
}

resource "kubernetes_cluster_role_binding" "karpenter_fix" {
  metadata {
    name = "karpenter_fix"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role.karpenter_fix.metadata[0].name
  }
  subject {
    kind      = "ServiceAccount"
    name      = "karpenter"
    namespace = kubernetes_namespace.this.metadata[0].name
  }
}
