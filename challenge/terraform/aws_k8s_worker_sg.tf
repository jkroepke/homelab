resource "aws_security_group" "worker" {
  name   = "${var.name}-worker"
  vpc_id = aws_vpc.vpc.id

  dynamic "ingress" {
    # https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/#check-required-ports
    for_each = {
      10250 : "Kubelet API"
    }
    content {
      description = ingress.value

      from_port = ingress.key
      protocol  = "tcp"
      to_port   = ingress.key

      security_groups = [aws_security_group.controller.id]
    }
  }

  ingress {
    from_port = 0
    protocol  = "-1"
    to_port   = 0

    security_groups = [aws_security_group.bastion.id]
  }

  egress {
    from_port = 0
    protocol  = "-1"
    to_port   = 0

    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}
