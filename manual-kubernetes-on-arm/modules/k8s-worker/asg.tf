resource "aws_autoscaling_group" "k8s_controller" {
  name = "${var.project_name}-controller"

  desired_capacity = 1
  max_size         = 1
  min_size         = 1

  vpc_zone_identifier = var.subnets

  launch_template {
    id      = aws_launch_template.k8s_controller.id
    version = aws_launch_template.k8s_controller.latest_version
  }

  instance_refresh {
    strategy = "Rolling"
  }
}

resource "aws_launch_template" "k8s_controller" {
  name = "${var.project_name}-controller"

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      encrypted             = true
      volume_size           = 20
      delete_on_termination = true
      volume_type           = "gp3"
    }
  }

  credit_specification {
    cpu_credits = "standard"
  }

  ebs_optimized = true
  instance_type = "t4g.micro"

  image_id = data.aws_ami.ubuntu2004.id

  instance_initiated_shutdown_behavior = "terminate"

  instance_market_options {
    market_type = "spot"
  }

  key_name = data.aws_key_pair.jkr.key_name

  # https://github.com/flatcar-linux/Flatcar/issues/220
  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "optional"
    http_put_response_hop_limit = 1

    http_protocol_ipv6 = "enabled"

    instance_metadata_tags = "enabled"
  }

  network_interfaces {
    associate_public_ip_address = false
    delete_on_termination       = true
    security_groups             = [aws_security_group.k8s_controller.id]
    ipv6_address_count          = 1
  }

  update_default_version = true

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name    = "${var.project_name}-controller"
      project = var.project_name
    }
  }
}
