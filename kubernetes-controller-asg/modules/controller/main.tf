resource "aws_launch_template" "this" {
  name                   = var.name
  update_default_version = true

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      iops        = 3000
      volume_size = 20
      volume_type = "gp3"
    }
  }

  credit_specification {
    cpu_credits = "standard"
  }

  disable_api_termination = false
  ebs_optimized           = true

  image_id = data.aws_ami.flatcar.id

  instance_market_options {
    market_type = "spot"
    spot_options {
      max_price = "0.50"
    }
  }

  instance_type = "t4g.small"
  key_name      = data.aws_key_pair.jkr.key_name

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "optional"
    http_put_response_hop_limit = 1
  }

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [var.vpc_security_group_id]
  }

  private_dns_name_options {
    hostname_type                        = "resource-name"
    enable_resource_name_dns_a_record    = true
    enable_resource_name_dns_aaaa_record = false
  }

  user_data = base64encode(data.ct_config.this.rendered)

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name                 = var.name
      etcd_peer_name       = var.etcd_peer_name
      etcd_volume_id       = aws_ebs_volume.this.id
      etcd_route53_zone_id = var.route53_zone_id
    }
  }

  depends_on = []
}

resource "aws_autoscaling_group" "this" {
  name = var.name

  desired_capacity = 1
  max_size         = 1
  min_size         = 1

  capacity_rebalance    = true
  target_group_arns     = [var.lb_target_group_arn]
  max_instance_lifetime = 0

  launch_template {
    id      = aws_launch_template.this.id
    version = aws_launch_template.this.latest_version
  }

  vpc_zone_identifier = [var.subnet_id]

  health_check_type = "EC2"

  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 0
    }
    triggers = ["tag"]
  }

  initial_lifecycle_hook {
    name                 = "lifecycle-launching"
    default_result       = "ABANDON"
    heartbeat_timeout    = 120
    lifecycle_transition = "autoscaling:EC2_INSTANCE_LAUNCHING"
  }

  initial_lifecycle_hook {
    name                 = "lifecycle-terminating"
    default_result       = "ABANDON"
    heartbeat_timeout    = 120
    lifecycle_transition = "autoscaling:EC2_INSTANCE_TERMINATING"
  }
}

resource "aws_ebs_volume" "this" {
  availability_zone = var.availability_zone

  size = 5
  type = "gp2"

  tags = {
    Name = "${var.name}-etcd"
  }
}
