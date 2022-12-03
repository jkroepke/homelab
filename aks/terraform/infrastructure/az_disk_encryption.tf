resource "azurerm_key_vault" "disk_encryption" {
  name                        = "kv-jok-des"
  location                    = azurerm_resource_group.default.location
  resource_group_name         = azurerm_resource_group.default.name
  tenant_id                   = data.azurerm_client_config.this.tenant_id
  sku_name                    = "premium"
  enabled_for_disk_encryption = true
  purge_protection_enabled    = true
}

resource "azurerm_key_vault_key" "disk_encryption" {
  name         = "kvk-jok-des"
  key_vault_id = azurerm_key_vault.disk_encryption.id
  key_type     = "RSA"
  key_size     = 2048

  depends_on = [
    azurerm_key_vault_access_policy.disk_encryption-user
  ]

  key_opts = [
    "decrypt",
    "encrypt",
    "sign",
    "unwrapKey",
    "verify",
    "wrapKey",
  ]
}

resource "azurerm_disk_encryption_set" "disk_encryption" {
  name                = "des"
  resource_group_name = azurerm_resource_group.default.name
  location            = azurerm_resource_group.default.location
  key_vault_key_id    = azurerm_key_vault_key.disk_encryption.id

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_key_vault_access_policy" "disk_encryption-disk" {
  key_vault_id = azurerm_key_vault.disk_encryption.id

  tenant_id = azurerm_disk_encryption_set.disk_encryption.identity.0.tenant_id
  object_id = azurerm_disk_encryption_set.disk_encryption.identity.0.principal_id

  key_permissions = [
    "Get",
    "WrapKey",
    "UnwrapKey",
  ]
}

resource "azurerm_key_vault_access_policy" "disk_encryption-user" {
  key_vault_id = azurerm_key_vault.disk_encryption.id

  tenant_id = data.azurerm_client_config.this.tenant_id
  object_id = data.azurerm_client_config.this.object_id

  key_permissions = [
    "Create",
    "Delete",
    "Get",
    "Purge",
    "Recover",
    "Update",
    "List",
    "Decrypt",
    "Sign"
  ]
}

resource "azurerm_role_assignment" "disk_encryption-disk" {
  scope                = azurerm_key_vault.disk_encryption.id
  role_definition_name = "Key Vault Crypto Service Encryption User"
  principal_id         = azurerm_disk_encryption_set.disk_encryption.identity.0.principal_id
}
