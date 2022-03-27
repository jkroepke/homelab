locals {
  subnet_availability_zones = zipmap(data.aws_availability_zones.this.names, range(length(data.aws_availability_zones.this.names)))
}

resource "aws_vpc" "this" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"

  assign_generated_ipv6_cidr_block = true

  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name                                = var.name
    "kubernetes.io/cluster/${var.name}" = "owned"
  }
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = var.name
  }
}

resource "aws_egress_only_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = var.name
  }
}

resource "aws_default_security_group" "this" {
  vpc_id = aws_vpc.this.id

  ingress {
    from_port        = 0
    protocol         = "-1"
    to_port          = 0
    cidr_blocks      = [aws_vpc.this.cidr_block]
    ipv6_cidr_blocks = [aws_vpc.this.ipv6_cidr_block]
  }

  tags = {
    Name = var.name
  }
}
