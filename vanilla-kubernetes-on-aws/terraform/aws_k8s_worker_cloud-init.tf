data "template_cloudinit_config" "worker" {
  gzip          = false
  base64_encode = true

  part {
    filename     = "10-os.yaml"
    content_type = "text/cloud-config"
    content      = file("cloud-init/10-os.yaml")
  }

  part {
    filename     = "20-cri-o.yaml"
    content_type = "text/cloud-config"
    content      = templatefile("cloud-init/20-cri-o.yaml", { versions = var.versions })
  }

  part {
    filename     = "30-kubernetes.yaml"
    content_type = "text/cloud-config"
    content      = templatefile("cloud-init/30-kubernetes.yaml", { versions = var.versions })
  }

  part {
    filename     = "99-kubernetes-worker.yaml"
    content_type = "text/cloud-config"
    content      = file("cloud-init/99-kubernetes-worker.yaml")
  }

  part {
    filename     = "kubeadm.yaml"
    content_type = "text/cloud-config"
    content = templatefile("cloud-init/parts/write_file.yaml", {
      path = "/etc/kubernetes/kubeadm.yaml"
      content = templatefile("cloud-init/files/etc/kubernetes/kubeadm.worker.yaml", {
        cluster_name    = var.name
        version         = var.versions.kubernetes
        kubernetes      = var.kubernetes
        bootstrap_token = local.bootstrap_token
      })
      mode = "0500"
    })
  }

  part {
    filename     = "10-crio.conf"
    content_type = "text/cloud-config"
    content = templatefile("cloud-init/parts/write_file.yaml", {
      path    = "/etc/systemd/system/kubelet.service.d/10-crio.conf"
      content = file("cloud-init/files/etc/systemd/system/kubelet.service.d/10-crio.conf")
      mode    = "0400"
    })
  }

  part {
    filename     = "kiam-iptables.service"
    content_type = "text/cloud-config"
    content = templatefile("cloud-init/parts/write_file.yaml", {
      path    = "/etc/systemd/system/kiam-iptables.service"
      content = file("cloud-init/files/etc/systemd/system/kiam-iptables.service")
      mode    = "0400"
    })
  }
}
