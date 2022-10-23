resource "azurerm_storage_account" "cortex" {
  name                     = "jokmspcortex"
  location                 = azurerm_resource_group.default.location
  resource_group_name      = azurerm_resource_group.default.name
  account_tier             = "Standard"
  account_replication_type = "LRS"

  cross_tenant_replication_enabled  = false
  shared_access_key_enabled         = false
  default_to_oauth_authentication   = true
  is_hns_enabled                    = false
  infrastructure_encryption_enabled = true

  blob_properties {
    versioning_enabled = false

    delete_retention_policy {
      days = 1
    }
  }
}

resource "azurerm_storage_container" "cortex_alertmanager" {
  name                  = "alertmanager"
  storage_account_name  = azurerm_storage_account.cortex.name
  container_access_type = "private"
}

resource "azurerm_storage_container" "cortex_ruler" {
  name                  = "ruler"
  storage_account_name  = azurerm_storage_account.cortex.name
  container_access_type = "private"
}

resource "azurerm_storage_container" "cortex_storage" {
  name                  = "cortex"
  storage_account_name  = azurerm_storage_account.cortex.name
  container_access_type = "private"
}

module "mi-cortex" {
  source              = "./modules/federated-managed-identity"
  name                = "cortex-storage-account"
  resource_group_name = azurerm_resource_group.default.name
  location            = azurerm_resource_group.default.location
  oidc_issuer_url     = azurerm_kubernetes_cluster.jok.oidc_issuer_url
  subject             = "system:serviceaccount:infra-cortex:cortex"
}

resource "azurerm_role_assignment" "mi-cortex-storage-account-storage-blob-data-contributor" {
  scope                = azurerm_storage_account.cortex.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = module.mi-cortex.principal_id
}
