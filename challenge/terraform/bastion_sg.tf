resource "aws_security_group" "bastion" {
  name = "${var.name}-bastion"
  vpc_id = aws_vpc.vpc.id

  ingress {
    description = "ICMP"

    from_port = -1
    protocol  = "icmp"
    to_port   = -1

    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description = "ICMP"

    from_port = -1
    protocol  = "icmpv6"
    to_port   = -1

    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description = "SSH"

    from_port = 22
    protocol  = "tcp"
    to_port   = 22

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
}
