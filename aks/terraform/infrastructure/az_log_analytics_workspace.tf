resource "azurerm_log_analytics_workspace" "default" {
  name                = "default"
  location            = azurerm_resource_group.jok-default.location
  resource_group_name = azurerm_resource_group.jok-default.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}
