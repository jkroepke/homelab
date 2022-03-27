locals {
  files_static_manifests = [
    templatefile("${path.module}/resources/ignition/parts/file_remote.yaml", {
      path    = "/etc/kubernetes/manifests/aws-encryption-provider.yaml"
      bucket  = aws_s3_bucket.this.bucket
      user    = "root"
      group   = "root"
      mode    = "0600"
      content = templatefile("${path.module}/resources/templates/etc/kubernetes/manifests/aws-encryption-provider.yaml", {
        region                    = data.aws_region.current.name
        kms_secret_encryption_arn = var.kms_secret_encryption_arn
      })
    }),
    templatefile("${path.module}/resources/ignition/parts/file_remote.yaml", {
      path    = "/etc/kubernetes/manifests/etcd.yaml"
      bucket  = aws_s3_bucket.this.bucket
      user    = "root"
      group   = "root"
      mode    = "0600"
      content = templatefile("${path.module}/resources/templates/etc/kubernetes/manifests/etcd.yaml", {
        etcd_discovery_domain = var.etcd_discovery_domain
        etcd_peer_name        = var.etcd_peer_name
        etcd_version          = var.etcd_version
      })
    }),
    templatefile("${path.module}/resources/ignition/parts/file_remote.yaml", {
      path    = "/etc/kubernetes/manifests/kube-apiserver.yaml"
      bucket  = aws_s3_bucket.this.bucket
      user    = "root"
      group   = "root"
      mode    = "0600"
      content = templatefile("${path.module}/resources/templates/etc/kubernetes/manifests/kube-apiserver.yaml", {
        kubernetes_version = var.kubernetes_version
        api_hostname = var.api_hostname
        oidc_issuer_url    = var.oidc_issuer_url
        service_cidr       = var.service_cidr
      })
    }),
    templatefile("${path.module}/resources/ignition/parts/file_remote.yaml", {
      path    = "/etc/kubernetes/manifests/kube-controller-manager.yaml"
      bucket  = aws_s3_bucket.this.bucket
      user    = "root"
      group   = "root"
      mode    = "0600"
      content = templatefile("${path.module}/resources/templates/etc/kubernetes/manifests/kube-controller-manager.yaml", {
        kubernetes_version = var.kubernetes_version
        cluster_name       = var.cluster_name
      })
    }),
    templatefile("${path.module}/resources/ignition/parts/file_remote.yaml", {
      path    = "/etc/kubernetes/manifests/kube-scheduler.yaml"
      bucket  = aws_s3_bucket.this.bucket
      user    = "root"
      group   = "root"
      mode    = "0600"
      content = templatefile("${path.module}/resources/templates/etc/kubernetes/manifests/kube-scheduler.yaml", {
        kubernetes_version = var.kubernetes_version
      })
    })
  ]
}
