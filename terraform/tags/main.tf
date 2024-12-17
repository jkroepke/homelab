terraform {
  required_providers {
    azapi = {
      source = "Azure/azapi"
    }
  }
}

provider "azapi" {
  subscription_id = "1988b893-553c-4652-bd9b-52f089b21ead"
}

provider "azurerm" {
  features {}

  subscription_id = "1988b893-553c-4652-bd9b-52f089b21ead"
}

resource "azurerm_resource_group" "tag" {
  location = "germanywestcentral"
  name     = "tags-test"

  lifecycle {
    ignore_changes = [
      tags,
    ]
  }
}

# PUT https://management.azure.com/{scope}/providers/Microsoft.Resources/tags/default?api-version=2021-04-01
resource "azapi_update_resource" "default" {
  type = "Microsoft.Resources/resourceGroups@2024-03-01"
  resource_id = azurerm_resource_group.tag.id

  body = {
    tags = {
      "tagKey1": "tag-value-1"
    }
  }
}

# https://learn.microsoft.com/en-us/rest/api/resources/tags?view=rest-resources-2021-04-01
# https://learn.microsoft.com/en-us/azure/templates/microsoft.resources/2024-03-01/tags?pivots=deployment-language-terraform
resource "azapi_update_resource" "tags" {
  type = "Microsoft.Resources/tags@2024-03-01"
  parent_id = azurerm_resource_group.tag.id
  name = "default"

  body = {
    properties = {
      tags = {
        "tagKey3" : "tag-value-3"
        "tagKey5" : "",
      }
    }
  }
}
