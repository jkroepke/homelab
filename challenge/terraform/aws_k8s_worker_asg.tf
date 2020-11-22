resource "aws_launch_template" "worker" {
  name_prefix   = "${var.name}-worker"
  image_id      = data.aws_ami.ubuntu.id
  instance_type = "t3a.large"

  key_name = aws_key_pair.ssh.key_name

  update_default_version = true

  iam_instance_profile {
    name = aws_iam_instance_profile.worker.name
  }

  ebs_optimized = true

  user_data = data.template_cloudinit_config.worker.rendered

  credit_specification {
    cpu_credits = "standard"
  }

  block_device_mappings {
    device_name = "/dev/sda1"

    ebs {
      volume_size = 50
    }
  }

  instance_initiated_shutdown_behavior = "terminate"

  instance_market_options {
    market_type = "spot"

    spot_options {
      spot_instance_type             = "one-time"
      max_price                      = "0.20"
      instance_interruption_behavior = "terminate"
    }
  }

  vpc_security_group_ids = [aws_security_group.worker.id]

  lifecycle {
    create_before_destroy = true
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name                                = "${var.name}-worker"
      project                             = var.name
      "kubernetes.io/cluster/${var.name}" = "owned"
    }
  }
}

resource "aws_autoscaling_group" "worker" {
  for_each = toset(var.availability_zones)

  name             = "${var.name}-worker-${each.value}"
  desired_capacity = 0
  max_size         = 3
  min_size         = 0

  health_check_type = "EC2"

  vpc_zone_identifier = [aws_subnet.subnet[each.key].id]

  launch_template {
    id      = aws_launch_template.worker.id
    version = aws_launch_template.worker.latest_version
  }

  # https://github.com/kubernetes/autoscaler/tree/master/charts/cluster-autoscaler-chart#aws---using-auto-discovery-of-tagged-instance-groups
  tags = [
    {
      key                 = "project"
      value               = var.name
      propagate_at_launch = false
    },
    {
      key                 = "kubernetes.io/cluster/${var.name}"
      value               = "owned"
      propagate_at_launch = false
    },
    {
      key                 = "k8s.io/cluster-autoscaler/enabled"
      value               = "true"
      propagate_at_launch = false
    },
    {
      key                 = "k8s.io/cluster-autoscaler/${var.name}"
      value               = "true"
      propagate_at_launch = false
    }
  ]
}
