module "mi-github-actions" {
  source              = "./modules/federated-managed-identity"
  name                = "github-actions"
  resource_group_name = azurerm_resource_group.default.name
  location            = azurerm_resource_group.default.location
  oidc_issuer_url     = "https://token.actions.githubusercontent.com"
  subjects = [
    "repo:jkroepke/homelab:ref:refs/heads/main",
    "repo:jkroepke/homelab:environment:aks-terraform-infrastructure",
    "repo:jkroepke/homelab:environment:aks-terraform-cluster",
  ]
}

# Reader and Data Access
# FIX: does not have authorization to perform action 'Microsoft.Storage/storageAccounts/listKeys/action' over scope
resource "azurerm_role_assignment" "mi-github-actions-reader" {
  for_each = toset(["Reader", "Reader and Data Access"])

  scope                = data.azurerm_subscription.current.id
  role_definition_name = each.key
  principal_id         = module.mi-github-actions.principal_id
}

resource "azurerm_key_vault_access_policy" "mi-github-actions-keyvault-access" {
  for_each = toset(local.aks_key_vaults)

  key_vault_id = data.azurerm_key_vault.aks[each.key].id
  tenant_id    = data.azurerm_client_config.this.tenant_id
  object_id    = module.mi-github-actions.principal_id

  secret_permissions = [
    "Get",
  ]
}
