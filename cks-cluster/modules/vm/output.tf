output "instance_id" {
  value = aws_instance.this.id
}

output "instance_ip_address" {
  value = aws_instance.this.ipv6_addresses[0]
}

output "security_group_id" {
  value = aws_security_group.this.id
}
