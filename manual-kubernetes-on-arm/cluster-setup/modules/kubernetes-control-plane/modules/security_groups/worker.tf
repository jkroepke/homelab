# https://kubernetes.io/docs/reference/ports-and-protocols/

# https://kubernetes.io/docs/reference/ports-and-protocols/

resource "aws_security_group" "worker" {
  name = "${var.cluster_name}-worker"

  vpc_id = var.vpc_id
  tags = {
    Name = "${var.cluster_name}-worker"
  }
}

resource "aws_security_group_rule" "worker-to-worker" {
  security_group_id = aws_security_group.worker.id
  description       = "inter-node communication"

  from_port = 0
  protocol  = "-1"
  to_port   = 0
  type      = "ingress"

  self = true
}

resource "aws_security_group_rule" "worker-kubelet" {
  security_group_id = aws_security_group.worker.id
  description       = "kubelet"

  from_port = 10250
  protocol  = "TCP"
  to_port   = 10250
  type      = "ingress"

  source_security_group_id = aws_security_group.controller.id
}

resource "aws_security_group_rule" "worker-egress" {
  security_group_id = aws_security_group.worker.id

  from_port = 0
  protocol  = "-1"
  to_port   = 0
  type      = "egress"

  cidr_blocks      = ["0.0.0.0/0"]
  ipv6_cidr_blocks = ["::/0"]
}
