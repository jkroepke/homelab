/*
resource "azurerm_communication_service" "this" {
  name                = "cm-jok"
  resource_group_name = azurerm_resource_group.jok-default.name
  data_location       = "Europe"
}
*/




resource "azapi_resource" "communication_services" {
  type      = "Microsoft.Communication/communicationServices@2023-03-31"
  name      = "cm-jok"
  location  = "global"
  parent_id = azurerm_resource_group.jok-default.id
  tags      = {}
  body = jsonencode({
    properties = {
      dataLocation  = "europe"
      linkedDomains = [
        azapi_resource.this.id
      ]
    }
  })

  response_export_values = ["*"]
}

resource "azurerm_email_communication_service" "this" {
  name                = "mail-jok"
  resource_group_name = azurerm_resource_group.jok-default.name
  data_location       = "Europe"
}

resource "azapi_resource" "this" {
  type      = "Microsoft.Communication/emailServices/domains@2023-03-31"
  name      = "AzureManagedDomain"
  location  = "global"
  parent_id = azurerm_email_communication_service.this.id
  tags      = {}
  body      = jsonencode({
    properties = {
      domainManagement       = "AzureManaged"
      userEngagementTracking = "Disabled"
    }
  })

  response_export_values = ["properties.mailFromSenderDomain"]
}

resource "azapi_resource" "mail_sender" {
  type      = "Microsoft.Communication/emailServices/domains/senderUsernames@2023-03-31"
  name      = "opsstack"
  parent_id = azapi_resource.this.id
  body      = jsonencode({
    properties = {
      displayName = "Ops.Stack Monitoring"
      username    = "opsstack"
    }
  })
}

# data "azapi_resource_action" "mail_keys" {
#   type                   = "Microsoft.Communication/CommunicationServices@2023-03-31"
#   resource_id            = azapi_resource.communication_services.id
#   action                 = "listKeys"
#   response_export_values = ["*"]
# }

output "domain" {
  value = jsondecode(azapi_resource.this.output)
}

output "communication_services" {
  value = jsondecode(azapi_resource.communication_services.output)
}

# output "mail_keys" {
#   value = jsondecode(data.azapi_resource_action.mail_keys.output)
# }
# smtp.azurecomm.net
