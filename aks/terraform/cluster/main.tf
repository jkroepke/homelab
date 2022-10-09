data "azurerm_client_config" "this" {}
data "azurerm_resource_group" "default" {
  name = "default"
}

data "azurerm_user_assigned_identity" "keyvault-access" {
  name                = "keyvault-access"
  resource_group_name = data.azurerm_resource_group.default.name
}

data "azurerm_key_vault" "dex" {
  name                = "kubernetes-dex"
  resource_group_name = "manual"
}

data "azurerm_key_vault_secret" "argocd-client-secret" {
  key_vault_id = data.azurerm_key_vault.dex.id
  name         = "argocd-client-secret"
}
