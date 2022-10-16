resource "azurerm_user_assigned_identity" "policy-azure-monitor" {
  name                = "policy-azure-monitor"
  resource_group_name = azurerm_resource_group.default.name
  location            = azurerm_resource_group.default.location
}

resource "azurerm_role_assignment" "mi-policy-azure-monitor-contributor" {
  scope                = azurerm_resource_group.default.id
  role_definition_name = "Contributor"
  principal_id         = azurerm_user_assigned_identity.policy-azure-monitor.principal_id
}
