resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr_block

  assign_generated_ipv6_cidr_block = true

  enable_dns_hostnames = true
  enable_dns_support = true

  tags = {
    Name = var.name
    project = var.name

    "kubernetes.io/cluster/${var.name}" = "owned",
  }
}

###########
# Routing #
###########

###
# https://github.com/terraform-aws-modules/terraform-aws-vpc/blob/master/main.tf#L13
###

# Regelt Traffic vom und zum Internet.
resource "aws_internet_gateway" "vpc" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name    = "${var.name}-gateway"
  }
}

resource "aws_default_route_table" "vpc" {
  default_route_table_id = aws_vpc.vpc.default_route_table_id

  tags = {
    Name = "${var.name}-default"
  }
}

resource "aws_route" "vpc_ipv4" {
  route_table_id            = aws_default_route_table.vpc.default_route_table_id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id                = aws_internet_gateway.vpc.id
}

resource "aws_route" "vpc_ipv6" {
  route_table_id              = aws_default_route_table.vpc.default_route_table_id
  destination_ipv6_cidr_block = "::/0"
  gateway_id                  = aws_internet_gateway.vpc.id
}
