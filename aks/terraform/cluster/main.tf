data "azurerm_client_config" "this" {}
data "azurerm_resource_group" "default" {
  name = "default"
}

data "azurerm_key_vault" "dex" {
  name                = "aks-credentials"
  resource_group_name = "manual"
}

data "azurerm_key_vault_secret" "argocd-client-secret" {
  key_vault_id = data.azurerm_key_vault.dex.id
  name         = "dexidp-argocd-secret"
}
