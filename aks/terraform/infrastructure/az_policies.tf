resource "azurerm_policy_definition" "vmss-vm-insights" {
  name         = "vmss-vm-insights"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Enable vmss insights on AKS nodes"

  # language=json
  policy_rule = <<POLICY_RULE
    {
      "if": {
        "allOf": [
          {
            "field": "type",
            "equals": "Microsoft.Compute/virtualMachineScaleSets"
          },
          {
            "field": "tags.aks-managed-poolName",
            "exists": true
          }
        ]
      },
      "then": {
        "effect": "DeployIfNotExists",
        "details": {
          "type": "Microsoft.Compute/virtualMachineScaleSets/extensions",
          "roleDefinitionIds": [
            "/providers/microsoft.authorization/roleDefinitions/9980e02c-c2be-4d73-94e8-173b1dc7cf3c"
          ],
          "existenceCondition": {
            "allOf": [
              {
                "field": "Microsoft.Compute/virtualMachineScaleSets/extensions/type",
                "equals": "AzureMonitorLinuxAgent"
              },
              {
                "field": "Microsoft.Compute/virtualMachineScaleSets/extensions/publisher",
                "equals": "Microsoft.Azure.Monitor"
              },
              {
                "field": "Microsoft.Compute/virtualMachineScaleSets/extensions/provisioningState",
                "equals": "Succeeded"
              }
            ]
          },
          "deployment": {
            "properties": {
              "mode": "incremental",
              "template": {
                "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                "contentVersion": "1.0.0.0",
                "parameters": {
                  "vmName": {
                    "type": "string"
                  },
                  "location": {
                    "type": "string"
                  }
                },
                "variables": {
                  "extensionName": "AzureMonitorLinuxAgent",
                  "extensionPublisher": "Microsoft.Azure.Monitor",
                  "extensionType": "AzureMonitorLinuxAgent",
                  "extensionTypeHandlerVersion": "1.21"
                },
                "resources": [
                  {
                    "name": "[concat(parameters('vmName'), '/', variables('extensionName'))]",
                    "type": "Microsoft.Compute/virtualMachineScaleSets/extensions",
                    "location": "[parameters('location')]",
                    "apiVersion": "2019-07-01",
                    "properties": {
                      "publisher": "[variables('extensionPublisher')]",
                      "type": "[variables('extensionType')]",
                      "typeHandlerVersion": "[variables('extensionTypeHandlerVersion')]",
                      "autoUpgradeMinorVersion": true,
                      "enableAutomaticUpgrade": true,
                      "settings": {
                        "authentication": {
                          "managedIdentity": {
                            "identifier-name": "mi_res_id",
                            "identifier-value": "[parameters('userAssignedManagedIdentity')]"
                          }
                        }
                      }
                    }
                  }
                ]
              },
              "parameters": {
                "vmName": {
                  "value": "[field('name')]"
                },
                "userAssignedManagedIdentity": {
                  "value": "${azurerm_user_assigned_identity.aks-kubelet.id}"
                }
              }
            }
          }
        }
      }
    }
POLICY_RULE
}

resource "azurerm_subscription_policy_assignment" "vmss-vm-insights" {
  name                 = "vmss-vm-insights"
  policy_definition_id = azurerm_policy_definition.vmss-vm-insights.id
  subscription_id      = data.azurerm_subscription.current.id

  location = azurerm_resource_group.default.location

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.aks.id]
  }
}
