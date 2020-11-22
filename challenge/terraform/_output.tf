output "controller" {
  value = {
    ip = { for k, v in aws_instance.controller : k => v.private_ip }
  }
}

output "kube_config" {
  value = local.admin_config_location
}
