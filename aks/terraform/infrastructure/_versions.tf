terraform {
  required_providers {
    azurerm = {}
    azapi = {
      source = "Azure/azapi"
    }

    azureakscommand = {
      source = "jkroepke/azureakscommand"
    }
  }
}
