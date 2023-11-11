data "azurerm_kubernetes_cluster" "jok" {
  name                = "jok"
  resource_group_name = "jok-mpn-default"
}

resource "azureakscommand_invoke" "example" {
  resource_group_name = data.azurerm_kubernetes_cluster.jok.resource_group_name
  name                = data.azurerm_kubernetes_cluster.jok.name

  command = "kubectl cluster-info"

  lifecycle {
    postcondition {
      condition     = self.exit_code == 0
      error_message = "exit code invalid"
    }
  }
}

output "azureakscommand_invoke" {
  value = azureakscommand_invoke.example.output
}

/*
data "external" "kubelogin" {
  program = [
    "kubelogin",
    "get-token",
    "--environment", "AzurePublicCloud",
    "--server-id", "6dae42f8-4368-4678-94ff-3960e28e3630",
    "--client-id", "80faf920-1908-4b52-b5ef-a8e7bedfc67a",
    "--tenant-id", data.azurerm_client_config.this.tenant_id,
    "--login", "devicecode"
  ]
}
*/
/*
# https://learn.microsoft.com/en-us/rest/api/aks/managed-clusters/run-command?tabs=HTTP
resource "azapi_resource_action" "runCommand" {
  type        = "Microsoft.ContainerService/managedClusters@2022-07-01"
  resource_id = data.azurerm_kubernetes_cluster.jok.id
  action      = "runCommand"

  response_export_values = ["*"]

  body = jsonencode({
    command      = "kubectl get pods",
    context      = ""
    clusterToken = var.clusterToken
  })
}
*/

/*
{
  "id" = "0d55d022a31f42fe877366c00588b30d"
  "properties" = {
    "exitCode" = 0
    "finishedAt" = "2022-10-25T17:48:21Z"
    "logs" = <<-EOT
    No resources found in default namespace.

    EOT
    "provisioningState" = "Succeeded"
    "startedAt" = "2022-10-25T17:48:17Z"
  }
}
*/

/*
output "command_output" {
  value = jsondecode(azapi_resource_action.runCommand.output)
}
*/
# https://management.azure.com/subscriptions/e1608e24-0728-4efd-ba5b-a05693b53c5a/resourceGroups/default/providers/Microsoft.ContainerService/managedClusters/jok/runCommand?api-version=2022-07-01
# https://management.azure.com/subscriptions/e1608e24-0728-4efd-ba5b-a05693b53c5a/resourceGroups/default/providers/Microsoft.ContainerService/managedClusters/jok/runCommand
