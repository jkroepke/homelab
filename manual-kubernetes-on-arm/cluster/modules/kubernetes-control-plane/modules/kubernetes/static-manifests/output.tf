output "manifests" {
  value = {
    "aws-encryption-provider.yaml" = templatefile("${path.module}/resources/aws-encryption-provider.yaml", {
      region                    = data.aws_region.current.name
      kms_secret_encryption_arn = var.kms_secret_encryption_arn
    })
    "etcd.yaml" = templatefile("${path.module}/resources/etcd.yaml", {
      etcd_discovery_domain = var.etcd_discovery_domain
      etcd_peer_name        = var.etcd_peer_name
      etcd_version          = var.etcd_version
    })
    "kube-apiserver.yaml" = templatefile("${path.module}/resources/kube-apiserver.yaml", {
      kubernetes_version = var.kubernetes_version
      oidc_issuer_url    = var.oidc_issuer_url
      service_cidr       = var.service_cidr
    })
    "kube-controller-manager.yaml" = templatefile("${path.module}/resources/kube-controller-manager.yaml", {
      kubernetes_version = var.kubernetes_version
      cluster_name       = var.cluster_name
    })
    "kube-scheduler.yaml" = templatefile("${path.module}/resources/kube-scheduler.yaml", {
      kubernetes_version = var.kubernetes_version
    })
  }
}
