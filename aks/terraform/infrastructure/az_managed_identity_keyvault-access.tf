module "mi-keyvault-access" {
  source              = "./modules/federated-managed-identity"
  name                = "keyvault-access"
  resource_group_name = azurerm_resource_group.default.name
  location            = azurerm_resource_group.default.location
  oidc_issuer_url     = azurerm_kubernetes_cluster.jok.oidc_issuer_url
  subject             = "system:serviceaccount:argocd:argocd-repo-server"
}

data "azurerm_key_vault" "aks" {
  for_each = toset(local.aks_key_vaults)

  name                = each.key
  resource_group_name = "manual"
}

resource "azurerm_key_vault_access_policy" "keyvault-access" {
  for_each = toset(local.aks_key_vaults)

  key_vault_id = data.azurerm_key_vault.aks[each.key].id
  tenant_id    = data.azurerm_client_config.this.tenant_id
  object_id    = module.mi-keyvault-access.principal_id

  secret_permissions = [
    "Get",
  ]
}
