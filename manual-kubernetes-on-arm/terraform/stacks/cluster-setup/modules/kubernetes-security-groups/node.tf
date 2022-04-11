# https://kubernetes.io/docs/reference/ports-and-protocols/
locals {
  rules_from_pod = { "node_exporter" = 9100, "kubelet" = 10250 }
}

resource "aws_security_group" "node" {
  name = "${var.name_prefix}-node"

  vpc_id = var.vpc_id
  tags = {
    Name = "${var.name_prefix}-node"
  }
}

resource "aws_security_group_rule" "node-ssh" {
  security_group_id = aws_security_group.node.id
  description       = "SSH"

  from_port = 22
  protocol  = "TCP"
  to_port   = 22
  type      = "ingress"

  ipv6_cidr_blocks = ["::/0"]
}

resource "aws_security_group_rule" "node-node" {
  security_group_id = aws_security_group.node.id
  description       = "inter-node communication"

  from_port = 0
  protocol  = "-1"
  to_port   = 0
  type      = "ingress"

  self = true
}

resource "aws_security_group_rule" "node-controller" {
  security_group_id = aws_security_group.node.id
  description       = "controller-to-node communication"

  from_port = 0
  protocol  = "-1"
  to_port   = 0
  type      = "ingress"

  source_security_group_id = aws_security_group.controller.id
}

resource "aws_security_group_rule" "node-pod" {
  for_each = local.rules_from_pod

  security_group_id = aws_security_group.node.id
  description       = "${each.key} from pod"

  from_port = each.value
  protocol  = "TCP"
  to_port   = each.value
  type      = "ingress"

  source_security_group_id = aws_security_group.pod.id
}


resource "aws_security_group_rule" "node-egress" {
  security_group_id = aws_security_group.node.id

  from_port = 0
  protocol  = "-1"
  to_port   = 0
  type      = "egress"

  cidr_blocks      = ["0.0.0.0/0"]
  ipv6_cidr_blocks = ["::/0"]
}
