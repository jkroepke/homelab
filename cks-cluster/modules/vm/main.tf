resource "aws_instance" "this" {
  ami           = var.ami_id
  instance_type = "t3a.medium"
  key_name      = var.key_name
  ebs_optimized = true

  subnet_id              = var.subnet_id
  vpc_security_group_ids = [aws_security_group.this.id]

  hibernation                          = true
  instance_initiated_shutdown_behavior = "stop"

  associate_public_ip_address = true
  ipv6_addresses              = [var.ip6_address]

  root_block_device {
    encrypted   = true
    volume_size = 50

    delete_on_termination = true

    tags = {
      Name = "${var.name}-root"
    }
  }

  user_data_base64 = data.template_cloudinit_config.this.rendered

  tags = {
    Name = var.name
  }
}

resource "aws_security_group" "this" {
  name   = var.name
  vpc_id = var.vpc_id
  tags = {
    Name = var.name
  }
}

resource "aws_security_group_rule" "this-ssh" {
  from_port         = 22
  protocol          = "TCP"
  security_group_id = aws_security_group.this.id
  to_port           = 22
  type              = "ingress"

  ipv6_cidr_blocks = ["::/0"]
}

resource "aws_security_group_rule" "this-node-ports" {
  from_port         = 30000
  protocol          = "TCP"
  security_group_id = aws_security_group.this.id
  to_port           = 40000
  type              = "ingress"

  cidr_blocks      = ["0.0.0.0/0"]
  ipv6_cidr_blocks = ["::/0"]
}
resource "aws_security_group_rule" "this-egress" {
  from_port         = 0
  protocol          = "-1"
  security_group_id = aws_security_group.this.id
  to_port           = 0
  type              = "egress"

  cidr_blocks      = ["0.0.0.0/0"]
  ipv6_cidr_blocks = ["::/0"]
}

data "template_cloudinit_config" "this" {
  gzip          = true
  base64_encode = true

  # Main cloud-config configuration file.
  part {
    filename     = "init.cfg"
    content_type = "text/cloud-config"
    content      = "hostname: ${var.name}"
  }
}
