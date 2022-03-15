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

  tags = {
    Name = var.name
  }
}

resource "aws_default_route_table" "default" {
  default_route_table_id = aws_vpc.this.default_route_table_id

  route {
    ipv6_cidr_block = "::/0"
    gateway_id      = aws_internet_gateway.this.id
  }

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  route {
    ipv6_cidr_block = "64:ff9b::/96"
    nat_gateway_id  = aws_nat_gateway.nat64.id
  }

  timeouts {
    create = "5m"
    update = "5m"
  }

  tags = {
    Name = var.name
  }
}
