# https://kubernetes.io/docs/reference/ports-and-protocols/

resource "aws_security_group" "controller" {
  name = "${var.cluster_name}-controller"

  vpc_id = var.vpc_id

  ingress {
    description = "SSH"
    from_port   = 22
    protocol    = "TCP"
    to_port     = 22

    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description = "kube-apiserver"
    from_port   = 6443
    to_port     = 6443
    protocol    = "TCP"

    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description = "etcd"
    from_port   = 2380
    to_port     = 2380
    protocol    = "TCP"

    self = true
  }

  egress {
    from_port = 0
    protocol  = "-1"
    to_port   = 0

    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "${var.cluster_name}-controller"
  }
}
