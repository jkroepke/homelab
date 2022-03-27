output "controller_security_group_id" {
  value = aws_security_group.controller.id
}

output "worker_security_group_id" {
  value = aws_security_group.worker.id
}
