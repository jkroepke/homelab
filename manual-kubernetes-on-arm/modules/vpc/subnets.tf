resource "aws_subnet" "this" {
  for_each = zipmap(data.aws_availability_zones.this.names, range(length(data.aws_availability_zones.this.names)))

  vpc_id            = aws_vpc.this.id
  availability_zone = each.key

  assign_ipv6_address_on_creation = true
  enable_dns64                    = true

  enable_resource_name_dns_a_record_on_launch    = false
  enable_resource_name_dns_aaaa_record_on_launch = true

  ipv6_native     = true
  ipv6_cidr_block = cidrsubnet(aws_vpc.this.ipv6_cidr_block, 8, each.value)

  tags = {
    Name                                = "${var.name}-native-${each.key}"
    "kubernetes.io/cluster/${var.name}" = "owned"
  }
}

resource "aws_subnet" "dual_stack" {
  for_each = zipmap(data.aws_availability_zones.this.names, range(length(data.aws_availability_zones.this.names)))

  vpc_id            = aws_vpc.this.id
  availability_zone = each.key

  assign_ipv6_address_on_creation = true

  cidr_block      = cidrsubnet(aws_vpc.this.cidr_block, 8, each.value)
  ipv6_cidr_block = cidrsubnet(aws_vpc.this.ipv6_cidr_block, 8, 64 + each.value)

  tags = {
    Name = "${var.name}-dual-stack-${each.key}"
  }
}
