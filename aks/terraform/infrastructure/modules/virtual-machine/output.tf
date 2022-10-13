output "vm_id" {
  value = azurerm_linux_virtual_machine.bastion.id
}

output "public_ipv4_id" {
  value = azurerm_public_ip.this["4"].id
}

output "public_ipv6_id" {
  value = azurerm_public_ip.this["6"].id
}

output "public_ipv4_ip" {
  value = azurerm_public_ip.this["4"].ip_address
}

output "public_ipv6_ip" {
  value = azurerm_public_ip.this["6"].ip_address
}
