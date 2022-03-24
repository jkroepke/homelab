data "template_cloudinit_config" "this" {
  gzip          = true
  base64_encode = true

  part {
    filename     = "10-os.yaml"
    content_type = "text/cloud-config"
    content      = file("${path.module}/templates/10-os.yaml")
  }

  part {
    filename     = "20-container-runtime.yaml"
    content_type = "text/cloud-config"
    content      = file("${path.module}/templates/20-container-runtime.yaml")
  }

  part {
    filename     = "30-kubernetes.yaml"
    content_type = "text/cloud-config"
    content      = templatefile("${path.module}/templates/30-kubernetes.yaml", {
      kubernetes_version = var.kubernetes_version
    })
  }

  part {
    filename     = "30-kubernetes.yaml"
    content_type = "text/cloud-config"
    content = templatefile("${path.module}/files/etc/systemd/system/kubelet.service.d/override.conf", {
      path    = "/etc/systemd/system/kubelet.service.d/override.conf"
      content = file("${path.module}/files/etc/systemd/system/kubelet.service.d/override.conf")
      owner   = "root:root"
      mode    = "0600"
    })
  }

  dynamic "part" {
    for_each = var.write_files

    content {
      filename     = basename(part.key)
      content_type = "text/cloud-config"
      content = templatefile("${path.module}/templates/parts/write_file.yaml", {
        path    = part.key
        owner   = part.value.owner
        content = part.value.content
        mode    = part.value.mode
      })
    }
  }
}
