output "master_ip" {
  value = module.master.instance_ip_address
}

output "worker_ip" {
  value = { for i in range(0, var.worker_count) : i => module.worker[i].instance_ip_address }
}

output "aws_start_all" {
  value = "aws --profile adorsys-sandbox ec2 start-instances --instance-ids ${module.master.instance_id} ${join(" ", module.worker[*].instance_id)}"
}
output "aws_stop_all" {
  value = "aws --profile adorsys-sandbox ec2 stop-instances --instance-ids ${module.master.instance_id} ${join(" ", module.worker[*].instance_id)}"
}
