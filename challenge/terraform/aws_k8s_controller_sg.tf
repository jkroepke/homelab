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

  ingress {
    description = "API"

    from_port = 6443
    protocol  = "tcp"
    to_port   = 6443

    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
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
