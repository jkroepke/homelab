resource "aws_security_group" "external" {
  name = "${var.name}-external"
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

  ingress {
    description = "HTTP"

    from_port = 6443
    protocol  = "tcp"
    to_port   = 6443

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

resource "aws_security_group" "internal" {
  name = "${var.name}-internal"
  vpc_id = aws_vpc.vpc.id

  ingress {
    from_port = 0
    protocol  = "-1"
    to_port   = 0

    self = true
  }

  egress {
    from_port = 0
    protocol  = "-1"
    to_port   = 0

    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}
