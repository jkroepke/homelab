output "bastion_ip4" {
  value = module.bastion.public_ipv4_ip
}

output "bastion_ip6" {
  value = module.bastion.public_ipv6_ip
}
