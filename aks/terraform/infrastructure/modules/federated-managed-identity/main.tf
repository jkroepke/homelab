resource "azurerm_user_assigned_identity" "this" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
}

# https://github.com/hashicorp/terraform-provider-azurerm/issues/18617
resource "azapi_resource" "federated_identity_credential" {
  for_each = toset(var.subjects)

  schema_validation_enabled = true
  name                      = replace(each.value, ":", "-")
  parent_id                 = azurerm_user_assigned_identity.this.id
  type                      = "Microsoft.ManagedIdentity/userAssignedIdentities/federatedIdentityCredentials@2022-01-31-preview"

  body = jsonencode({
    properties = {
      issuer    = var.oidc_issuer_url
      subject   = each.value
      audiences = ["api://AzureADTokenExchange"]
    }
  })
}
