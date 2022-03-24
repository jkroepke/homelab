resource "aws_instance" "worker" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3a.medium"
  key_name      = data.aws_key_pair.jkr.key_name

  subnet_id              = module.vpc.public_subnets[0]
  vpc_security_group_ids = [aws_security_group.worker.id]

  associate_public_ip_address = true
  ipv6_address_count          = 0
  ipv6_addresses              = [local.worker_ip]

  root_block_device {
    encrypted   = true
    volume_size = 50

    delete_on_termination = true

    tags = {
      Name = "${var.project}-worker-root"
    }
  }

  user_data_base64 = data.template_cloudinit_config.worker.rendered

  tags = {
    Name = "${var.project}-worker"
  }
}

resource "aws_security_group" "worker" {
  vpc_id = module.vpc.vpc_id
}

resource "aws_security_group_rule" "worker-ssh" {
  from_port         = 22
  protocol          = "TCP"
  security_group_id = aws_security_group.worker.id
  to_port           = 22
  type              = "ingress"

  ipv6_cidr_blocks = ["::/0"]
}

resource "aws_security_group_rule" "worker-egress" {
  from_port         = 0
  protocol          = "-1"
  security_group_id = aws_security_group.worker.id
  to_port           = 0
  type              = "egress"

  cidr_blocks      = ["0.0.0.0/0"]
  ipv6_cidr_blocks = ["::/0"]
}

data "template_cloudinit_config" "worker" {
  gzip          = true
  base64_encode = true

  # Main cloud-config configuration file.
  part {
    filename     = "init.cfg"
    content_type = "text/cloud-config"
    content      = "hostname: ${var.project}-worker"
  }
}
