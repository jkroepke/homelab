output "vm_id" {
  value = local.virtual_machine_id
}

output "vm_name" {
  value = local.virtual_machine_name
}

output "public_ipv4_id" {
  value = try(azurerm_public_ip.this["4"].id, null)
}

output "public_ipv4_ip" {
  value = try(azurerm_public_ip.this["4"].ip_address, null)
}

output "azurerm_linux_virtual_machine" {
  value = azurerm_linux_virtual_machine.this
}
