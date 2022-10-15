resource "azurerm_user_assigned_identity" "this" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
}

resource "null_resource" "federated-credentials" {
  triggers = {
    id                  = azurerm_user_assigned_identity.this.id
    name                = var.name
    subject             = var.subject
    oidc_issuer_url     = var.oidc_issuer_url
    resource_group_name = var.resource_group_name
  }

  # https://learn.microsoft.com/en-us/azure/aks/workload-identity-deploy-cluster
  # https://github.com/hashicorp/terraform-provider-azurerm/issues/18617
  provisioner "local-exec" {
    command = join(" ", [
      "az", "identity", "federated-credential", "create",
      "--resource-group ${self.triggers.resource_group_name}",
      "--identity-name ${self.triggers.name}",
      "--name ${replace(self.triggers.subject, ":", "-")}",
      "--issuer ${self.triggers.oidc_issuer_url}",
      "--subject ${var.subject}",
    ])
  }

  provisioner "local-exec" {
    when = destroy
    command = join(" ", [
      "az", "identity", "federated-credential", "delete",
      "--resource-group ${self.triggers.resource_group_name}",
      "--identity-name ${self.triggers.name}",
      "--name argocd--argocd-repo-server",
      "--yes",
    ])
  }
}

/*
resource "azapi_resource" "federated-credentials" {
  type      = "Microsoft.ContainerRegistry/registries@2020-11-01-preview"
  name      = "registry1"
  parent_id = azurerm_resource_group.example.id

  location = azurerm_resource_group.example.location
  identity {
    type         = "SystemAssigned, UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.example.id]
  }

  body = jsonencode({
    sku = {
      name = "Standard"
    }
    properties = {
      adminUserEnabled = true
    }
  })

  tags = {
    "Key" = "Value"
  }

  response_export_values = ["properties.loginServer", "properties.policies.quarantinePolicy.status"]
}
*/
