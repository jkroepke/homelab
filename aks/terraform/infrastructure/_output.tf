output "bastion_ip" {
  value = module.bastion_linux.public_ipv4_ip
}

output "vm_id" {
  value = module.bastion_linux.azurerm_linux_virtual_machine[0].id
}

output "subscription_id" {
  value = data.azurerm_subscription.current.subscription_id
}

output "tenant_id" {
  value = data.azurerm_subscription.current.tenant_id
}
