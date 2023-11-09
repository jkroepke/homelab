provider "azurerm" {
  features {
    log_analytics_workspace {
      permanently_delete_on_destroy = true
    }
  }

  skip_provider_registration = true

  tenant_id       = "9c1de352-64a4-4509-b3fc-4ef2df8db9b8"
  subscription_id = "1988b893-553c-4652-bd9b-52f089b21ead"
}

provider "azapi" {
  tenant_id       = "9c1de352-64a4-4509-b3fc-4ef2df8db9b8"
  subscription_id = "1988b893-553c-4652-bd9b-52f089b21ead"
}
