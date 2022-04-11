# https://kubernetes.io/docs/reference/ports-and-protocols/

# https://kubernetes.io/docs/reference/ports-and-protocols/

resource "aws_security_group" "pod" {
  name = "${var.name_prefix}-pod"

  vpc_id = var.vpc_id
  tags = {
    Name = "${var.name_prefix}-pod"
  }
}

resource "aws_security_group_rule" "pod-to-pod" {
  security_group_id = aws_security_group.pod.id
  description       = "inter-pod communication"

  from_port = 0
  protocol  = "-1"
  to_port   = 0
  type      = "ingress"

  self = true
}

resource "aws_security_group_rule" "pod-controller" {
  security_group_id = aws_security_group.pod.id
  description       = "controller-to-pod communication"

  from_port = 0
  protocol  = "-1"
  to_port   = 0
  type      = "ingress"

  source_security_group_id = aws_security_group.controller.id
}

resource "aws_security_group_rule" "pod-node" {
  security_group_id = aws_security_group.pod.id
  description       = "node-to-pod communication"

  from_port = 0
  protocol  = "-1"
  to_port   = 0
  type      = "ingress"

  source_security_group_id = aws_security_group.node.id
}

resource "aws_security_group_rule" "pod-egress" {
  security_group_id = aws_security_group.pod.id

  from_port = 0
  protocol  = "-1"
  to_port   = 0
  type      = "egress"

  cidr_blocks      = ["0.0.0.0/0"]
  ipv6_cidr_blocks = ["::/0"]
}
