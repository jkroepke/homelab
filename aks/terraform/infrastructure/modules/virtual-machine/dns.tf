resource "azurerm_dns_a_record" "this" {
  name                = var.name
  zone_name           = var.dns_zone_name
  resource_group_name = var.dns_resource_group_name
  ttl                 = 300
  target_resource_id  = azurerm_public_ip.this["4"].id
}

resource "azurerm_dns_aaaa_record" "this" {
  name                = var.name
  zone_name           = var.dns_zone_name
  resource_group_name = var.dns_resource_group_name
  ttl                 = 300
  target_resource_id  = azurerm_public_ip.this["6"].id
}

moved {
  from = azurerm_dns_a_record.bastion4
  to   = azurerm_dns_a_record.this
}

moved {
  from = azurerm_dns_aaaa_record.bastion6
  to   = azurerm_dns_aaaa_record.this
}
