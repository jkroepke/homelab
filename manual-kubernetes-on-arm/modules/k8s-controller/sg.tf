resource "aws_security_group" "this" {
  name = "${var.project_name}-controller"

  vpc_id = var.vpc_id

  tags = {
    Name = "${var.project_name}-controller"
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

resource "aws_security_group_rule" "egress" {
  security_group_id = aws_security_group.this.id

  from_port = 0
  protocol  = "-1"
  to_port   = 0
  type      = "egress"

  ipv6_cidr_blocks = ["::/0"]
}
