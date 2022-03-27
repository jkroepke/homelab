locals {
  etcd_domain = "etcd.internal"
  etcd_peers  = { for i in range(1, var.controller_count + 1) : i => "etcd${i}.${local.etcd_domain}" }
  controllers = { for i in range(1, var.controller_count + 1) : i => values(var.vpc_private_subnets)[i - 1] }
}

module "cloud-init" {
  for_each = local.controllers

  source = "./modules/ignition"

  index              = each.key
  cluster_name       = var.cluster_name
  etcd_peer_name     = local.etcd_peers[each.key]
  etcd_version       = var.etcd_version
  kubernetes_version = var.kubernetes_version

  pod_cidr    = var.pod_cidr
  cluster_dns = var.cluster_dns

  iam_instance_role = aws_iam_role.this.arn

  files = merge(
    local.files_pki_etcd[each.key],
    local.files_pki_kubernetes,
    local.files_kubernetes_configs,
    local.files_kubernetes_static_manifests[each.key],
  )
}

resource "aws_instance" "this" {
  for_each = local.controllers

  ami           = data.aws_ami.flatcar.id
  ebs_optimized = true

  user_data                   = module.cloud-init[each.key].rendered
  user_data_replace_on_change = true

  credit_specification {
    cpu_credits = "standard"
  }

  key_name             = data.aws_key_pair.jkr.key_name
  instance_type        = "t4g.small"
  iam_instance_profile = aws_iam_instance_profile.this.name

  metadata_options {
    http_endpoint = "enabled"
    # https://github.com/flatcar-linux/Flatcar/issues/220#issuecomment-1079653927
    http_tokens                 = "optional"
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
  vpc_security_group_ids = [
    module.security_groups.controller_security_group_id,
    module.security_groups.worker_security_group_id,
  ]

  depends_on = [aws_route53_record.etcd_discovery, aws_lb_target_group.this]

  tags = {
    Name = "${var.cluster_name}-controller-${each.key}"
  }
}

resource "aws_lb_target_group_attachment" "this" {
  for_each = local.controllers

  target_group_arn = aws_lb_target_group.this.arn
  target_id        = aws_instance.this[each.key].id
}
