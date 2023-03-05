module "mi-monitoring-reader" {
  source              = "./modules/federated-managed-identity"
  name                = "aks-monitoring-reader"
  resource_group_name = azurerm_resource_group.jok-default.name
  location            = azurerm_resource_group.jok-default.location
  oidc_issuer_url     = azurerm_kubernetes_cluster.jok.oidc_issuer_url
  subjects = [
    "system:serviceaccount:infra-prometheus:grafana"
  ]
}

resource "azurerm_role_assignment" "mi-monitoring-reader-reader" {
  scope                = azurerm_resource_group.jok-default.id
  role_definition_name = "Reader"
  principal_id         = module.mi-monitoring-reader.principal_id
}

resource "azurerm_role_assignment" "mi-monitoring-reader-monitoring-reader" {
  scope                = azurerm_resource_group.jok-default.id
  role_definition_name = "Monitoring Reader"
  principal_id         = module.mi-monitoring-reader.principal_id
}

resource "azurerm_role_assignment" "mi-monitoring-reader-log-analytics-reader" {
  scope                = azurerm_resource_group.jok-default.id
  role_definition_name = "Log Analytics Reader"
  principal_id         = module.mi-monitoring-reader.principal_id
}
