resource "kubernetes_config_map" "external-dns-azure-config-file" {
  metadata {
    name      = "azure-config-file"
    namespace = kubernetes_namespace.managed-identities["external-dns"].metadata[0].name
  }

  data = {
    "azure.json" = jsonencode({
      "tenantId"                    = data.azurerm_client_config.this.tenant_id,
      "subscriptionId"              = data.azurerm_client_config.this.subscription_id,
      "resourceGroup"               = data.azurerm_resource_group.manual.name,
      "useManagedIdentityExtension" = true,
      "userAssignedIdentityID"      = data.azurerm_user_assigned_identity.external-dns.client_id
    })
  }
}

