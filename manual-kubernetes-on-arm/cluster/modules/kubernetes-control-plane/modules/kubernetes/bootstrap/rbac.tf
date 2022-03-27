resource "kubernetes_cluster_role_binding" "create-csrs-for-bootstrapping" {
  metadata {
    name = "create-csrs-for-bootstrapping"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "system:node-bootstrapper"
  }
  subject {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Group"
    name      = "system:bootstrappers"
  }
}

resource "kubernetes_cluster_role_binding" "auto-approve-csrs-for-group" {
  metadata {
    name = "auto-approve-csrs-for-group"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "system:certificates.k8s.io:certificatesigningrequests:nodeclient"
  }
  subject {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Group"
    name      = "system:bootstrappers"
  }
}

resource "kubernetes_cluster_role_binding" "auto-approve-renewals-for-nodes" {
  metadata {
    name = "auto-approve-renewals-for-nodes"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "system:certificates.k8s.io:certificatesigningrequests:selfnodeclient"
  }
  subject {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Group"
    name      = "system:nodes"
  }
}
