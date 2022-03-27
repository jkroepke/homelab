resource "aws_security_group" "this" {
  name = "${var.cluster_name}-controller"

  vpc_id = var.vpc_id

  tags = {
    Name = "${var.cluster_name}-controller"
  }
}

resource "aws_security_group_rule" "ingress" {
  security_group_id = aws_security_group.this.id

  description = "SSH"
  from_port   = 22
  to_port     = 22
  protocol    = "TCP"
  type        = "ingress"

  ipv6_cidr_blocks = ["::/0"]
}

resource "aws_security_group_rule" "ingress-kubernetes-apiserver" {
  security_group_id = aws_security_group.this.id

  description = "kube-apiserver"
  from_port   = 6443
  to_port     = 6443
  protocol    = "TCP"
  type        = "ingress"

  cidr_blocks      = [var.vpc_cidr_ipv4]
  ipv6_cidr_blocks = [var.vpc_cidr_ipv6]
}

resource "aws_security_group_rule" "egress" {
  security_group_id = aws_security_group.this.id

  from_port = 0
  protocol  = "-1"
  to_port   = 0
  type      = "egress"

  cidr_blocks      = ["0.0.0.0/0"]
  ipv6_cidr_blocks = ["::/0"]
}
