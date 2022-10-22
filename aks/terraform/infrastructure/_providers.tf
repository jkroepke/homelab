provider "azurerm" {
  features {}

  tenant_id       = "9c1de352-64a4-4509-b3fc-4ef2df8db9b8"
  subscription_id = "e1608e24-0728-4efd-ba5b-a05693b53c5a"

  skip_provider_registration = true
  storage_use_azuread        = true
}
