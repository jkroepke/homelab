output "controller" {
  value = {
    ip = {for k,v in aws_instance.controller: k => v.private_ip}
  }
}
