resource "aws_security_group" "this" {
  name = "${var.project}-ssh-any"

  vpc_id = data.aws_vpc.this.id

  ingress {
    from_port = 22
    protocol  = "TCP"
    to_port   = 22

    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    protocol  = "-1"
    to_port   = 0

    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project}-ssh-any"
  }
}
