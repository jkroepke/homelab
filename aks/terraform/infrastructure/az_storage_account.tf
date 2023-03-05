resource "azurerm_storage_account" "aks" {
  name                     = "jokmspaks"
  location                 = azurerm_resource_group.jok-default.location
  resource_group_name      = azurerm_resource_group.jok-default.name
  account_tier             = "Standard"
  account_replication_type = "LRS"

  cross_tenant_replication_enabled  = false
  shared_access_key_enabled         = true
  default_to_oauth_authentication   = true
  is_hns_enabled                    = false
  infrastructure_encryption_enabled = true

  blob_properties {
    versioning_enabled = false

    delete_retention_policy {
      days = 1
    }
  }

  share_properties {
    smb {
      versions                        = ["SMB3.1.1"]
      authentication_types            = ["NTLMv2", "Kerberos"]
      kerberos_ticket_encryption_type = ["AES-256"]
      channel_encryption_type         = ["AES-128-GCM", "AES-256-GCM"]
    }
  }
}

resource "azurerm_storage_container" "cortex_alertmanager" {
  name                  = "alertmanager"
  storage_account_name  = azurerm_storage_account.aks.name
  container_access_type = "private"
}

resource "azurerm_storage_container" "cortex_ruler" {
  name                  = "ruler"
  storage_account_name  = azurerm_storage_account.aks.name
  container_access_type = "private"
}

resource "azurerm_storage_container" "cortex_storage" {
  name                  = "cortex"
  storage_account_name  = azurerm_storage_account.aks.name
  container_access_type = "private"
}

resource "azurerm_storage_container" "loki" {
  name                  = "loki"
  storage_account_name  = azurerm_storage_account.aks.name
  container_access_type = "private"
}

resource "azurerm_storage_management_policy" "loki" {
  storage_account_id = azurerm_storage_account.aks.id

  rule {
    name    = "loki"
    enabled = true
    filters {
      prefix_match = [azurerm_storage_container.loki.name]
      blob_types   = ["blockBlob"]
    }
    actions {
      base_blob {
        delete_after_days_since_modification_greater_than = 28
      }
      snapshot {
        delete_after_days_since_creation_greater_than = 28
      }
    }
  }
}

resource "azurerm_storage_container" "loki-ruler" {
  name                  = "loki-ruler"
  storage_account_name  = azurerm_storage_account.aks.name
  container_access_type = "private"
}

module "mi-cortex" {
  source              = "./modules/federated-managed-identity"
  name                = "aks-storage-account"
  resource_group_name = azurerm_resource_group.jok-default.name
  location            = azurerm_resource_group.jok-default.location
  oidc_issuer_url     = azurerm_kubernetes_cluster.jok.oidc_issuer_url
  subjects = [
    "system:serviceaccount:infra-loki:loki",
    "system:serviceaccount:infra-cortex:cortex"
  ]
}

resource "azurerm_role_assignment" "mi-aks-storage-account-storage-blob-data-contributor" {
  scope                = azurerm_storage_account.aks.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = module.mi-cortex.principal_id
}
