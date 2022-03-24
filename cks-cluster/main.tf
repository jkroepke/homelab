locals {
  availability_zone = data.aws_availability_zones.current.names[0]

  master_ip = cidrhost(aws_subnet.this[local.availability_zone].ipv6_cidr_block, 10)
  worker_ip = cidrhost(aws_subnet.this[local.availability_zone].ipv6_cidr_block, 11)
}
