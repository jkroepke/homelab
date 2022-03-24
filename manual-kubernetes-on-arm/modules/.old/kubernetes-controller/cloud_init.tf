data "template_cloudinit_config" "controller" {
  gzip          = false
  base64_encode = false

  part {
    filename     = "10-os.yaml"
    content_type = "text/cloud-config"
    content      = file("${path.module}/cloud-init/10-os.yaml")
  }

  part {
    filename     = "20-container-runtime.yaml"
    content_type = "text/cloud-config"
    content      = file("${path.module}/cloud-init/20-container-runtime.yaml")
  }

  part {
    filename     = "30-kubernetes.yaml"
    content_type = "text/cloud-config"
    content      = templatefile("${path.module}/cloud-init/30-kubernetes.yaml", { kubernetes_version = var.kubernetes_version })
  }

  part {
    filename     = "ca.key"
    content_type = "text/cloud-config"
    content = templatefile("${path.module}/cloud-init/parts/write_file.yaml", {
      path    = "/etc/kubernetes/pki/ca.key"
      content = module.tls_etcd.etcd_tls
      mode    = "0600"
    })
  }
}
