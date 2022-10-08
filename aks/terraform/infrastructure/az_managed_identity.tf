resource "azurerm_user_assigned_identity" "keyvault-access" {
  name                = "keyvault-access"
  resource_group_name = data.azurerm_resource_group.default.name
  location            = "eastus2"
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
      "az",
      "identity",
      "federated-credential",
      "create",
      "--name argocd--argocd-repo-server",
      "--resource-group ${azurerm_user_assigned_identity.keyvault-access.resource_group_name}",
      "--identity-name ${azurerm_user_assigned_identity.keyvault-access.name}",
      "--issuer ${azurerm_kubernetes_cluster.jok.oidc_issuer_url}",
      "--subject system:serviceaccount:argocd:argocd-repo-server",
    ])
  }
}
