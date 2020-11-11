data "template_cloudinit_config" "controller" {
  gzip          = false
  base64_encode = false

  part {
    filename     = "instance-kickstart"
    content_type = "text/cloud-config"
    content      = templatefile("cloud-init/parts/write_file.yaml", {
      path    = "/usr/local/bin/control-plan-kickstart"
      content = file("cloud-init/files/usr/local/bin/control-plan-kickstart")
      mode    = "0700"
    })
  }

  part {
    filename     = "10-os.yaml"
    content_type = "text/cloud-config"
    content      = file("cloud-init/10-os.yaml")
  }

  part {
    filename     = "20-cri-o.yaml"
    content_type = "text/cloud-config"
    content      = templatefile("cloud-init/20-cri-o.yaml", {versions = var.versions})
  }

  part {
    filename     = "30-kubernetes.yaml"
    content_type = "text/cloud-config"
    content      = templatefile("cloud-init/30-kubernetes.yaml", {versions = var.versions})
  }

  part {
    filename     = "kubeadm.yaml"
    content_type = "text/cloud-config"
    content      = templatefile("cloud-init/parts/write_file.yaml", {
      path    = "/etc/kubernetes/kubeadm.yaml"
      content = templatefile("cloud-init/files/etc/kubernetes/kubeadm.controller.yaml", {
        cluster_name       = var.name
        version            = var.versions.kubernetes
        kubernetes         = var.kubernetes
        bootstrap_token    = local.bootstrap_token
        encryption_key     = local.encryption_key
      })
      mode    = "0500"
    })
  }

  part {
    filename     = "10-crio.conf"
    content_type = "text/cloud-config"
    content      = templatefile("cloud-init/parts/write_file.yaml", {
      path    = "/etc/systemd/system/kubelet.service.d/10-crio.conf"
      content = file("cloud-init/files/etc/systemd/system/kubelet.service.d/10-crio.conf")
      mode    = "0400"
    })
  }

  part {
    filename     = "ca.key"
    content_type = "text/cloud-config"
    content      = templatefile("cloud-init/parts/write_file.yaml", {
      path    = "/etc/kubernetes/pki/ca.key"
      content = tls_private_key.kubernetes-ca.private_key_pem
      mode    = "0600"
    })
  }

  part {
    filename     = "ca.crt"
    content_type = "text/cloud-config"
    content      = templatefile("cloud-init/parts/write_file.yaml", {
      path    = "/etc/kubernetes/pki/ca.crt"
      content = tls_self_signed_cert.kubernetes-ca.cert_pem
      mode    = "0600"
    })
  }
}
