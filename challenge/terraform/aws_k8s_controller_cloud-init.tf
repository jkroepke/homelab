data "template_cloudinit_config" "controller" {
  for_each = local.controller_nodes

  gzip          = false
  base64_encode = false

  part {
    filename     = "instance-kickstart"
    content_type = "text/cloud-config"
    content      = templatefile("cloud-init/parts/write_file.yaml", {
      path    = "/usr/local/bin/instance-kickstart"
      content = file("cloud-init/files/usr/local/bin/instance-kickstart")
      mode    = "0700"
    })
  }

  part {
    filename     = "os.yaml"
    content_type = "text/cloud-config"
    content      = templatefile("cloud-init/os.yaml", {instance_name = each.key})
  }

  part {
    filename     = "cri-o.yaml"
    content_type = "text/cloud-config"
    content      = templatefile("cloud-init/cri-o.yaml", {versions = var.versions})
  }

  part {
    filename     = "kubernetes.yaml"
    content_type = "text/cloud-config"
    content      = templatefile("cloud-init/kubernetes.yaml", {versions = var.versions})
  }

  part {
    filename     = "kubeadm.yaml"
    content_type = "text/cloud-config"
    content      = templatefile("cloud-init/parts/write_file.yaml", {
      path    = "/etc/kubernetes/kubeadm.yaml"
      content = templatefile("cloud-init/files/etc/kubernetes/kubeadm.yaml", {
        cluster_name       = var.name
        api_hostname       = var.kubernetes.api_hostname
        version            = var.versions.kubernetes
        service_cidr_block = var.kubernetes.service_cidr_block
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
