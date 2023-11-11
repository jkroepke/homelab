terraform {
  backend "azurerm" {
    tenant_id            = "9c1de352-64a4-4509-b3fc-4ef2df8db9b8"
    subscription_id      = "1988b893-553c-4652-bd9b-52f089b21ead"
    resource_group_name  = "manual"
    storage_account_name = "stjokmanual"
    container_name       = "tfstate"
    key                  = "run-command-test.tfstate"
  }
}
