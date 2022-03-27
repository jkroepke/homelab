resource "aws_subnet" "private" {
  for_each = local.subnet_availability_zones

  vpc_id            = aws_vpc.this.id
  availability_zone = each.key

  assign_ipv6_address_on_creation = true
  enable_dns64                    = false
  map_public_ip_on_launch         = false

  enable_resource_name_dns_a_record_on_launch    = true
  enable_resource_name_dns_aaaa_record_on_launch = true

  private_dns_hostname_type_on_launch = "resource-name"

  cidr_block      = cidrsubnet(var.private_subnet_cidr, 4, each.value)
  ipv6_cidr_block = cidrsubnet(aws_vpc.this.ipv6_cidr_block, 8, var.private_ipv6_net_id + each.value)

  tags = {
    Name                                = "${var.name}-private-${each.key}"
    "kubernetes.io/cluster/${var.name}" = "owned"
  }
}

resource "aws_subnet" "public" {
  for_each = local.subnet_availability_zones

  vpc_id            = aws_vpc.this.id
  availability_zone = each.key

  assign_ipv6_address_on_creation = true
  enable_dns64                    = false
  map_public_ip_on_launch         = true

  enable_resource_name_dns_a_record_on_launch    = true
  enable_resource_name_dns_aaaa_record_on_launch = true

  private_dns_hostname_type_on_launch = "resource-name"

  cidr_block      = cidrsubnet(var.public_subnet_cidr, 4, each.value)
  ipv6_cidr_block = cidrsubnet(aws_vpc.this.ipv6_cidr_block, 8, var.public_ipv6_net_id + each.value)

  tags = {
    Name = "${var.name}-public-${each.key}"
  }
}

resource "aws_subnet" "kubernetes_service" {
  for_each = local.subnet_availability_zones

  vpc_id            = aws_vpc.this.id
  availability_zone = each.key

  assign_ipv6_address_on_creation = false
  enable_dns64                    = false
  map_public_ip_on_launch         = false

  cidr_block      = cidrsubnet(var.kubernetes_service_subnet_cidr, 4, each.value)
  ipv6_cidr_block = cidrsubnet(aws_vpc.this.ipv6_cidr_block, 8, var.kubernetes_service_ipv6_net_id + each.value)

  tags = {
    Name = "${var.name}-kubernetes-service-${each.key}"
  }
}

resource "aws_subnet" "kubernetes_pod" {
  for_each = local.subnet_availability_zones

  vpc_id            = aws_vpc.this.id
  availability_zone = each.key

  assign_ipv6_address_on_creation = false
  enable_dns64                    = false
  map_public_ip_on_launch         = false

  cidr_block      = cidrsubnet(var.kubernetes_pod_subnet_cidr, 4, each.value)
  ipv6_cidr_block = cidrsubnet(aws_vpc.this.ipv6_cidr_block, 8, var.kubernetes_pod_ipv6_net_id + each.value)

  tags = {
    Name = "${var.name}-kubernetes-pod-${each.key}"
  }
}
