output "id" {
  value = aws_vpc.this.id
}

output "subnet_ids" {
  value = {for az, subnet in aws_subnet.this : az => subnet.id}
}
