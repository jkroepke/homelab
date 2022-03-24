output "master_ip" {
  value = aws_instance.master.ipv6_addresses[0]
}

output "worker_ip" {
  value = aws_instance.worker.ipv6_addresses[0]
}
