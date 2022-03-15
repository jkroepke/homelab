output "security_group_id" {
  value = aws_security_group.this.id
}

output "k8s_controller_ips" {
  value = { for name, controller in aws_instance.this : name => controller.ipv6_addresses }
}
