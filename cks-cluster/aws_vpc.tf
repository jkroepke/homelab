resource "aws_vpc" "this" {
  cidr_block                       = "10.0.0.0/16"
  assign_generated_ipv6_cidr_block = true
  enable_dns_support               = true
  enable_dns_hostnames             = true

  tags = {
    Name = var.project
  }
}

resource "aws_subnet" "this" {
  for_each = toset([data.aws_availability_zones.current.names[0]])

  vpc_id = aws_vpc.this.id

  cidr_block      = cidrsubnet(aws_vpc.this.cidr_block, 8, 8)
  ipv6_cidr_block = cidrsubnet(aws_vpc.this.ipv6_cidr_block, 8, 8)

  assign_ipv6_address_on_creation = false
  availability_zone               = each.key

  tags = {
    Name = "${var.project}-${each.key}"
  }
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = var.project
  }
}

resource "aws_default_route_table" "this" {
  default_route_table_id = aws_vpc.this.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  route {
    ipv6_cidr_block = "::/0"
    gateway_id      = aws_internet_gateway.this.id
  }
}
