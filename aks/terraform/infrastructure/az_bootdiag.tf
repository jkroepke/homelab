resource "azurerm_storage_account" "bootdiag" {
  name                     = "jokmspbootdiag"
  location                 = azurerm_resource_group.jok-default.location
  resource_group_name      = azurerm_resource_group.jok-default.name
  account_tier             = "Standard"
  account_replication_type = "LRS"
}
