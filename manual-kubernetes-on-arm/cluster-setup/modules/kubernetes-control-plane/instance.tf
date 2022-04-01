resource "aws_instance" "this" {
  for_each = local.controllers

  ami           = data.aws_ami.flatcar.id
  ebs_optimized = true

  user_data                   = module.ignition[each.key].rendered
  user_data_replace_on_change = true

  credit_specification {
    cpu_credits = "standard"
  }

  key_name             = data.aws_key_pair.jkr.key_name
  instance_type        = var.instance_type
  iam_instance_profile = module.iam.iam_instance_profile_name

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

  subnet_id = each.value
  vpc_security_group_ids = [
    module.security_groups.controller_security_group_id,
    module.security_groups.worker_security_group_id,
  ]

  depends_on = [aws_route53_record.etcd_discovery, module.api_loadbalancer]

  tags = {
    Name                                        = "${var.cluster_name}-controller-${each.key}"
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
  }
}

resource "aws_lb_target_group_attachment" "this" {
  for_each = local.controllers

  target_group_arn = module.api_loadbalancer.lb_target_group_arn
  target_id        = aws_instance.this[each.key].id
}
