# https://kubernetes.io/docs/reference/ports-and-protocols/

resource "aws_security_group" "worker" {
  name = "${var.cluster_name}-worker"

  vpc_id = var.vpc_id

  ingress {
    description = "Kubelet API"
    from_port   = 10250
    to_port     = 10250
    protocol    = "TCP"

    security_groups = [aws_security_group.controller.id]
  }

  ingress {
    description = "NodePort Services"
    from_port   = 30000
    to_port     = 32767
    protocol    = "TCP"

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

  tags = {
    Name = "${var.cluster_name}-controller"
  }
}
