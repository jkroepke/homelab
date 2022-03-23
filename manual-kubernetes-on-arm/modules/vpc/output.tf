output "id" {
  value = aws_vpc.this.id
}

output "public_subnets" {
  value = { for az, subnet in aws_subnet.public : az => subnet.id }
}

output "private_subnets" {
  value = { for az, subnet in aws_subnet.private : az => subnet.id }
}
