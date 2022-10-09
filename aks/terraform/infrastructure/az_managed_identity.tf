data "azurerm_key_vault" "aks" {
  for_each = toset(local.aks_key_vaults)

  name                = each.key
  resource_group_name = "manual"
}

resource "azurerm_user_assigned_identity" "keyvault-access" {
  name                = "keyvault-access"
  resource_group_name = azurerm_resource_group.default.name
  location            = azurerm_resource_group.default.location
}

resource "azurerm_key_vault_access_policy" "keyvault-access" {
  for_each = toset(local.aks_key_vaults)

  key_vault_id = data.azurerm_key_vault.aks[each.key].id
  tenant_id    = data.azurerm_client_config.this.tenant_id
  object_id    = azurerm_user_assigned_identity.keyvault-access.principal_id

  secret_permissions = [
    "Get",
  ]
}

resource "null_resource" "federated-credentials" {
  triggers = {
    id     = azurerm_user_assigned_identity.keyvault-access.id
    issuer = azurerm_kubernetes_cluster.jok.oidc_issuer_url
  }

  # https://learn.microsoft.com/en-us/azure/aks/workload-identity-deploy-cluster
  # https://github.com/hashicorp/terraform-provider-azurerm/issues/18617
  provisioner "local-exec" {
    command = join(" ", [
      "az", "identity", "federated-credential", "create",
      "--name argocd--argocd-repo-server",
      "--resource-group ${azurerm_user_assigned_identity.keyvault-access.resource_group_name}",
      "--identity-name ${azurerm_user_assigned_identity.keyvault-access.name}",
      "--issuer ${azurerm_kubernetes_cluster.jok.oidc_issuer_url}",
      "--subject system:serviceaccount:argocd:argocd-repo-server",
    ])
  }
  provisioner "local-exec" {
    when = destroy
    command = join(" ", [
      "az", "identity", "federated-credential", "delete",
      "--name argocd--argocd-repo-server"
    ])
  }
}
