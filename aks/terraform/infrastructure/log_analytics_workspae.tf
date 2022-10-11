resource "azurerm_log_analytics_workspace" "jok" {
  name                = "jok"
  location            = azurerm_resource_group.default.location
  resource_group_name = azurerm_resource_group.default.name
  sku                 = "Free"
  retention_in_days   = 3
}
