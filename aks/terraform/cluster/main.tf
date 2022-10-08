data "azurerm_client_config" "this" {}
data "azurerm_resource_group" "default" {
  name = "default"
}

data "azurerm_user_assigned_identity" "keyvault-access" {
  name                = "keyvault-access"
  resource_group_name = data.azurerm_resource_group.default.name
}
