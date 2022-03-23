data "template_cloudinit_config" "controller" {
  gzip          = false
  base64_encode = false

  part {
    filename     = "10-os.yaml"
    content_type = "text/cloud-config"
    content      = file("${path.module}/cloud-init/10-os.yaml")
  }

  part {
    filename     = "30-kubernetes.yaml"
    content_type = "text/cloud-config"
    content      = templatefile("${path.module}/cloud-init/30-kubernetes.yaml", { kubernetes_version = var.kubernetes_version })
  }

  part {
    filename     = "10-crio.conf"
    content_type = "text/cloud-config"
    content = templatefile("${path.module}/cloud-init/parts/write_file.yaml", {
      path    = "/etc/systemd/system/kubelet.service.d/10-crio.conf"
      content = file("${path.module}/cloud-init/files/etc/systemd/system/kubelet.service.d/10-crio.conf")
      mode    = "0400"
    })
  }

  part {
    filename     = "ca.key"
    content_type = "text/cloud-config"
    content = templatefile("${path.module}/cloud-init/parts/write_file.yaml", {
      path    = "/etc/kubernetes/pki/ca.key"
      content = tls_private_key.kubernetes-ca.private_key_pem
      mode    = "0600"
    })
  }

  part {
    filename     = "ca.crt"
    content_type = "text/cloud-config"
    content = templatefile("${path.module}/cloud-init/parts/write_file.yaml", {
      path    = "/etc/kubernetes/pki/ca.crt"
      content = tls_self_signed_cert.kubernetes-ca.cert_pem
      mode    = "0600"
    })
  }
}
