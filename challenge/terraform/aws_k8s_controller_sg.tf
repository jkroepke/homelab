resource "aws_security_group" "controller" {
  name = "${var.name}-controller"
  vpc_id = aws_vpc.vpc.id

  dynamic "ingress" {
    # https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/#check-required-ports
    for_each = {
      2379: "etcd client"
      2380: "etcd peer"
      10250: "Kubelet API"
    }
    content {
      description = ingress.value

      from_port = ingress.key
      protocol  = "tcp"
      to_port   = ingress.key

      self = true
    }
  }

  dynamic "ingress" {
    # https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/#check-required-ports
    for_each = {
      32080: "Ingress HTTP"
      32443: "Ingress HTTPS"
      6443: "K8S API"
    }
    content {
      description = ingress.value

      from_port = ingress.key
      protocol  = "tcp"
      to_port   = ingress.key

      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
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
