output "id" {
  value = aws_vpc.this.id
}

output "cidr_block" {
  value = aws_vpc.this.cidr_block
}

output "ipv6_cidr_block" {
  value = aws_vpc.this.ipv6_cidr_block
}

output "public_subnets" {
  value = { for az, subnet in aws_subnet.public : az => subnet.id }
}

output "private_subnets" {
  value = { for az, subnet in aws_subnet.private : az => subnet.id }
}
