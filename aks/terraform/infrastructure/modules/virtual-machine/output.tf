output "vm_id" {
  value = local.virtual_machine_id
}

output "vm_name" {
  value = local.virtual_machine_name
}

output "public_ipv4_id" {
  value = try(azurerm_public_ip.this["4"].id, null)
}

output "public_ipv6_id" {
  value = try(azurerm_public_ip.this["6"].id, null)
}

output "public_ipv4_ip" {
  value = try(azurerm_public_ip.this["4"].ip_address, null)
}

output "public_ipv6_ip" {
  value = try(azurerm_public_ip.this["6"].ip_address, null)
}
