resource "azurerm_dns_a_record" "this" {
  count = var.enable_public_interface ? 1 : 0

  name                = var.name
  zone_name           = var.dns_zone_name
  resource_group_name = var.dns_resource_group_name
  ttl                 = 300
  target_resource_id  = azurerm_public_ip.this["4"].id
}

resource "azurerm_dns_aaaa_record" "this" {
  count = var.enable_public_interface ? 1 : 0

  name                = var.name
  zone_name           = var.dns_zone_name
  resource_group_name = var.dns_resource_group_name
  ttl                 = 300
  target_resource_id  = azurerm_public_ip.this["6"].id
}
