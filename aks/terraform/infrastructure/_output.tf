output "bastion_ip4" {
  value = module.bastion_linux.public_ipv4_ip
}

output "bastion_ip6" {
  value = module.bastion_linux.public_ipv6_ip
}
