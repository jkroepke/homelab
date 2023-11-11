provider "azurerm" {
  features {}

  tenant_id       = "9c1de352-64a4-4509-b3fc-4ef2df8db9b8"
  subscription_id = "1988b893-553c-4652-bd9b-52f089b21ead"

  skip_provider_registration = true
}

data "azurerm_subscription" "this" {}

provider "azureakscommand" {
  tenant_id       = data.azurerm_subscription.this.tenant_id
  subscription_id = data.azurerm_subscription.this.subscription_id
}


