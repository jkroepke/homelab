resource "azurerm_user_assigned_identity" "aks" {
  name                = "jok-aks"
  resource_group_name = azurerm_resource_group.default.name
  location            = azurerm_resource_group.default.location
}

resource "azurerm_role_assignment" "mi-aks-contributor" {
  scope                = azurerm_resource_group.default.id
  role_definition_name = "Contributor"
  principal_id         = azurerm_user_assigned_identity.aks.principal_id
}

resource "azurerm_role_assignment" "mi-aks-mi-operator" {
  scope                = azurerm_user_assigned_identity.aks-kubelet.id
  role_definition_name = "Managed Identity Operator"
  principal_id         = azurerm_user_assigned_identity.aks.principal_id
}

resource "azurerm_role_assignment" "mi-aks-monitoring-metrics-publisher" {
  scope                = azurerm_resource_group.default.id
  role_definition_name = "Monitoring Metrics Publisher"
  principal_id         = azurerm_user_assigned_identity.aks.principal_id
}

resource "azurerm_user_assigned_identity" "aks-kubelet" {
  name                = "jok-aks-kubelet"
  resource_group_name = azurerm_resource_group.default.name
  location            = azurerm_resource_group.default.location
}
