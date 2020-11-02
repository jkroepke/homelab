locals {
  ansible_vars = {
    versions = var.versions
    kubernetes = merge({
      api: aws_route53_zone.dns.name
    }, var.kubernetes)
    etcd = {
      discovery_srv = "etcd.${aws_route53_zone.dns.name}"
    }
  }
}

data "template_cloudinit_config" "controller" {
  for_each = local.controller_nodes

  gzip          = false
  base64_encode = false

  part {
    filename     = "kickstart.yaml"
    content_type = "text/cloud-config"
    content      = file("cloud-init/kickstart.yaml")
  }

  part {
    filename     = "disks.yaml"
    content_type = "text/cloud-config"
    content      = templatefile("cloud-init/disks.yaml", {
      count = 2
      ebs = {
        etcd = replace(aws_ebs_volume.controller_etcd[each.key].id, "-", "")
      }
    })
  }

  part {
    filename     = "vars.yml"
    content_type = "text/cloud-config"
    content      = templatefile("cloud-init/parts/write_file.yaml", {
      path = "/etc/ansible/vars.yml"
      content = yamlencode(local.ansible_vars)
    })
  }

  part {
    filename     = "etcd.key"
    content_type = "text/cloud-config"
    content      = templatefile("cloud-init/parts/write_file.yaml", {
      path = "/etc/etcd/ca.key"
      content = tls_private_key.etcd-ca.private_key_pem
    })
  }

  part {
    filename     = "etcd.key"
    content_type = "text/cloud-config"
    content      = templatefile("cloud-init/parts/write_file.yaml", {
      path = "/etc/etcd/ca.crt"
      content = tls_self_signed_cert.etcd-ca.cert_pem
    })
  }

  part {
    filename     = "kubernetes.key"
    content_type = "text/cloud-config"
    content      = templatefile("cloud-init/parts/write_file.yaml", {
      path = "/etc/kubernetes/pki/ca.key"
      content = tls_private_key.kubernetes-ca.private_key_pem
    })
  }

  part {
    filename     = "etcd.key"
    content_type = "text/cloud-config"
    content      = templatefile("cloud-init/parts/write_file.yaml", {
      path = "/etc/kubernetes/pki/ca.crt"
      content = tls_self_signed_cert.kubernetes-ca.cert_pem
    })
  }

  part {
    filename     = "kubernetes.key"
    content_type = "text/cloud-config"
    content      = templatefile("cloud-init/parts/write_file.yaml", {
      path = "/etc/kubernetes/pki/ca.key"
      content = tls_private_key.front-proxy-ca.private_key_pem
    })
  }

  part {
    filename     = "etcd.key"
    content_type = "text/cloud-config"
    content      = templatefile("cloud-init/parts/write_file.yaml", {
      path = "/etc/kubernetes/pki/ca.crt"
      content = tls_self_signed_cert.front-proxy-ca.cert_pem
    })
  }
}
