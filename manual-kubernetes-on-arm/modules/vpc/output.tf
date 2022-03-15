output "id" {
  value = aws_vpc.this.id
}

output "subnets" {
  value = { for az, subnet in aws_subnet.this : az => subnet.id }
}
