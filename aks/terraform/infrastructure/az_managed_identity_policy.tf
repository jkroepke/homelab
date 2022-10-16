resource "azurerm_user_assigned_identity" "policy-azure-monitor" {
  name                = "policy-azure-monitor"
  resource_group_name = azurerm_resource_group.default.name
  location            = azurerm_resource_group.default.location
}

resource "azurerm_role_assignment" "mi-policy-azure-monitor-virtual-machine-contributor" {
  scope                = data.azurerm_subscription.current.id
  role_definition_name = "Virtual Machine Contributor"
  principal_id         = azurerm_user_assigned_identity.policy-azure-monitor.principal_id
}

resource "azurerm_role_assignment" "mi-policy-monitoring-contributor" {
  scope                = data.azurerm_subscription.current.id
  role_definition_name = "Monitoring Contributor"
  principal_id         = azurerm_user_assigned_identity.policy-azure-monitor.principal_id
}
