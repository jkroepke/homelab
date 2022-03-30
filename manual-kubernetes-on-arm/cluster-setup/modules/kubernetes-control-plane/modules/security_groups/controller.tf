# https://kubernetes.io/docs/reference/ports-and-protocols/

resource "aws_security_group" "controller" {
  name = "${var.cluster_name}-controller"

  vpc_id = var.vpc_id
  tags = {
    Name = "${var.cluster_name}-controller"
  }
}

resource "aws_security_group_rule" "controller-ssh" {
  security_group_id = aws_security_group.controller.id
  description       = "SSH"

  from_port = 22
  protocol  = "TCP"
  to_port   = 22
  type      = "ingress"

  ipv6_cidr_blocks = ["::/0"]
}

resource "aws_security_group_rule" "controller-dns" {
  for_each          = toset(["TCP", "UDP"])
  security_group_id = aws_security_group.controller.id
  description       = "DNS ${each.key}"

  from_port = 53
  protocol  = each.key
  to_port   = 53
  type      = "ingress"

  source_security_group_id = aws_security_group.worker.id
}

resource "aws_security_group_rule" "controller-etcd" {
  security_group_id = aws_security_group.controller.id
  description       = "etcd"

  from_port = 2380
  protocol  = "TCP"
  to_port   = 2380
  type      = "ingress"

  self = true
}

resource "aws_security_group_rule" "controller-kube-apiserver" {
  security_group_id = aws_security_group.controller.id
  description       = "kube-apiserver"

  from_port = 6443
  protocol  = "TCP"
  to_port   = 6443
  type      = "ingress"

  cidr_blocks      = ["0.0.0.0/0"]
  ipv6_cidr_blocks = ["::/0"]
}

resource "aws_security_group_rule" "controller-kubelet" {
  security_group_id = aws_security_group.controller.id
  description       = "kubelet"

  from_port = 10250
  protocol  = "TCP"
  to_port   = 10250
  type      = "ingress"

  self = true
}

resource "aws_security_group_rule" "controller-egress" {
  security_group_id = aws_security_group.controller.id

  from_port = 0
  protocol  = "-1"
  to_port   = 0
  type      = "egress"

  cidr_blocks      = ["0.0.0.0/0"]
  ipv6_cidr_blocks = ["::/0"]
}
