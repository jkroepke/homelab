resource "aws_launch_template" "this" {
  name                   = var.name
  update_default_version = true

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      delete_on_termination = true
      encrypted             = true
      iops                  = 3000
      volume_size           = var.volume_size
      volume_type           = "gp3"
    }
  }

  credit_specification {
    cpu_credits = "standard"
  }

  disable_api_termination = false
  ebs_optimized           = true

  iam_instance_profile {
    name = var.iam_instance_profile_name
  }

  image_id = data.aws_ami.flatcar.id

  instance_market_options {
    market_type = "spot"
  }

  instance_type = var.instance_type
  key_name      = data.aws_key_pair.jkr.key_name

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "optional"
    http_put_response_hop_limit = 1
  }

  private_dns_name_options {
    hostname_type                        = "resource-name"
    enable_resource_name_dns_a_record    = true
    enable_resource_name_dns_aaaa_record = true
  }

  user_data              = base64encode(var.user_data)
  vpc_security_group_ids = var.vpc_security_group_ids

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name                                        = var.name
      project                                     = var.cluster_name
      etcd_peer_name                              = var.etcd_peer_name
      etcd_volume_id                              = aws_ebs_volume.this.id
      etcd_route53_zone_id                        = var.etcd_route53_zone_id
      "kubernetes.io/cluster/${var.cluster_name}" = "owned"

      # https://github.com/kubernetes/cloud-provider-aws/blob/8d2f0fd2b1b574bde3239a344bd0a9a4f244cdb0/pkg/providers/v1/aws.go#L303
      "kubernetes.io/role/master" = "true"

      trigger = "tag"
    }
  }
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

  health_check_type = "ELB"

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
    heartbeat_timeout    = 300
    lifecycle_transition = "autoscaling:EC2_INSTANCE_LAUNCHING"
  }

  initial_lifecycle_hook {
    name                 = "lifecycle-terminating"
    default_result       = "ABANDON"
    heartbeat_timeout    = 300
    lifecycle_transition = "autoscaling:EC2_INSTANCE_TERMINATING"
  }

  tag {
    key                 = "kubernetes.io/cluster/${var.cluster_name}"
    propagate_at_launch = false
    value               = "owned"
  }
}

resource "aws_ebs_volume" "this" {
  availability_zone = var.availability_zone

  encrypted = true
  iops      = 3000
  size      = var.etcd_volume_size
  type      = "gp3"

  tags = {
    Name = "${var.name}-etcd"
  }
}
