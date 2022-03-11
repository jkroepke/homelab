data "aws_ami" "flatcar_arm" {
  most_recent = true
  owners      = ["075585003325"]

  filter {
    name   = "architecture"
    values = ["arm64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "name"
    values = ["Flatcar-beta-*"]
  }
}

resource "aws_autoscaling_group" "k8s_controller" {
  name_prefix = "${local.project}-controller"

  desired_capacity   = 1
  max_size           = 1
  min_size           = 1

  vpc_zone_identifier = values(module.vpc.subnet_ids)

  launch_template {
    id      = aws_launch_template.k8s_controller.id
    version = "$Latest"
  }
}

resource "aws_launch_template" "k8s_controller" {
  name = "${local.project}-controller"

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

  image_id = data.aws_ami.flatcar_arm.id

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

    http_protocol_ipv6          = "enabled"

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
      Name = "${local.project}-controller"
      project = local.project
    }
  }
}

resource "aws_security_group" "k8s_controller" {
  name = "${local.project}-controller"

  vpc_id = module.vpc.id

  tags = {
    Name = "${local.project}-controller"
  }

  ingress {
    description = "SSH"

    from_port = 22
    protocol  = "tcp"
    to_port   = 22

    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port = 0
    protocol  = "-1"
    to_port   = 0

    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}
