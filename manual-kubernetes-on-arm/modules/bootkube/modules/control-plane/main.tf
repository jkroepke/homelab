locals {
  etcd_domain = "etcd.internal"
  etcd_peers  = {for i in range(1, var.controller_count + 1) : i => "etcd${i}.${local.etcd_domain}"}
  controllers = {for i in range(1, var.controller_count + 1) : i => values(var.vpc_subnets)[i - 1]}
}

module "etcd" {
  source      = "./modules/pki/etcd"
  etcd_domain = local.etcd_domain
  etcd_peers  = local.etcd_peers
}

module "cloud-init" {
  for_each = local.controllers

  source       = "./modules/cloud-init"

  cluster_name       = var.cluster_name
  etcd_peer_name     = local.etcd_peers[each.key]
  etcd_version       = var.etcd_version
  kubernetes_version = var.kubernetes_version
  write_files        = {
    "/etc/kubernetes/pki/etcd/ca.crt"                 = {
      content = module.etcd.ca
      owner = "root:root"
      mode  = "0666"
    }
    "/etc/kubernetes/pki/etcd/server.key"             = {
      content = module.etcd.server_key
      owner = "etcd:etcd"
      mode  = "0600"
    }
    "/etc/kubernetes/pki/etcd/server.crt"             = {
      content = module.etcd.server_crt
      owner = "root:root"
      mode  = "0666"
    }
    "/etc/kubernetes/pki/etcd/peer.key"             = {
      content = module.etcd.peer_key[each.key]
      owner = "etcd:etcd"
      mode  = "0600"
    }
    "/etc/kubernetes/pki/etcd/peer.crt"             = {
      content = module.etcd.peer_crt[each.key]
      owner = "root:root"
      mode  = "0666"
    }
    "/etc/kubernetes/pki/etcd/healthcheck-client.key"             = {
      content = module.etcd.healthcheck_client_key
      owner = "etcd:etcd"
      mode  = "0600"
    }
    "/etc/kubernetes/pki/etcd/healthcheck-client.crt"             = {
      content = module.etcd.healthcheck_client_crt
      owner = "root:root"
      mode  = "0666"
    }
    "/etc/kubernetes/pki/apiserver-etcd-client.key"             = {
      content = module.etcd.apiserver_etcd_client_key
      owner = "etcd:etcd"
      mode  = "0600"
    }
    "/etc/kubernetes/pki/apiserver-etcd-client.crt"             = {
      content = module.etcd.apiserver_etcd_client_crt
      owner = "root:root"
      mode  = "0666"
    }
  }
}

resource "aws_instance" "this" {
  for_each = local.controllers

  ami           = data.aws_ami.ubuntu2004.id
  ebs_optimized = true

  user_data_base64 = module.cloud-init[each.key].rendered

  credit_specification {
    cpu_credits = "standard"
  }

  key_name             = data.aws_key_pair.jkr.key_name
  instance_type        = "t4g.micro"
  iam_instance_profile = aws_iam_instance_profile.this.name

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
  }

  root_block_device {
    encrypted             = true
    volume_size           = 30
    delete_on_termination = true

    tags = {
      Name    = "${var.cluster_name}-controller-${each.key}"
      project = var.cluster_name
    }
  }

  subnet_id              = each.value
  vpc_security_group_ids = [aws_security_group.this.id]

  tags = {
    Name = "${var.cluster_name}-controller-${each.key}"
  }
}
