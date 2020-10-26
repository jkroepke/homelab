resource "aws_subnet" "subnet" {
  for_each = {for k, v in var.availability_zones: v => k}

  vpc_id            = aws_vpc.vpc.id
  availability_zone = each.key

  cidr_block      = cidrsubnet(aws_vpc.vpc.cidr_block, 8, 0 + each.value)
  ipv6_cidr_block = cidrsubnet(aws_vpc.vpc.ipv6_cidr_block, 8, 0 + each.value)

  tags = {
    Name = "${var.name}-node-${each.key}"
    project = var.name

    "kubernetes.io/cluster/${var.name}" = "owned"
  }
}
