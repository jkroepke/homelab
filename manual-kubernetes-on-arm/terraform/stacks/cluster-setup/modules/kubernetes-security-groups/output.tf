output "controller_security_group_id" {
  value = aws_security_group.controller.id
}

output "node_security_group_id" {
  value = aws_security_group.node.id
}
