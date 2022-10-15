data "azurerm_client_config" "this" {}
data "azurerm_resource_group" "default" {
  name = "default"
}
data "azurerm_resource_group" "manual" {
  name = "manual"
}

data "azurerm_key_vault" "aks-credentials" {
  name                = "aks-credentials"
  resource_group_name = data.azurerm_resource_group.manual.name
}

data "azurerm_key_vault_secret" "aks-credentials" {
  for_each = toset([
    "dexidp-argocd-secret",
    "argocd-notifications-github-app-id",
    "argocd-notifications-github-client-id",
    "argocd-notifications-github-client-secret",
  ])

  key_vault_id = data.azurerm_key_vault.aks-credentials.id
  name         = each.key
}
