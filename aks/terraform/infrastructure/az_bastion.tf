module "bastion" {
  source = "./modules/virtual-machine"

  name                                 = "bastion"
  resource_group_name                  = azurerm_resource_group.default.name
  location                             = azurerm_resource_group.default.location
  subnet_id                            = azurerm_subnet.default.id
  boot_diagnostics_storage_account_uri = azurerm_storage_account.bootdiag.primary_blob_endpoint
  dns_zone_name                        = data.azurerm_dns_zone.aks_jkroepke_de.name
  dns_resource_group_name              = data.azurerm_dns_zone.aks_jkroepke_de.resource_group_name
  public_key                           = local.public_key
}
