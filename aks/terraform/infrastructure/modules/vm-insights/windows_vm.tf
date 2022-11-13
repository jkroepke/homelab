resource "azurerm_policy_definition" "vm-insights-extension" {
  name         = "VMInsights: Deploy Azure Monitor Agent"
  policy_type  = "Custom"
  mode         = "Indexed"
  display_name = "VMInsights: Deploy Azure Monitor Agent"

  metadata = jsonencode({ category: "Monitoring" })

  #{
  #"field": "[if(equals(parameters('resourceType'), 'Microsoft.Compute/virtualMachines'), concat(parameters('resourceType'), '/storageProfile.osDisk.osType'), concat(parameters('resourceType'), '/virtualMachineProfile.storageProfile.osDisk.osType'))]",
  #"equals": "[parameters('osType')]"
  #},

  # language=json
  policy_rule = <<POLICY_RULE
{
  "if": {
    "allOf": [
      {
        "field": "type",
        "equals": "[parameters('resourceType')]"
      },
      {
        "field": "identity.type",
        "contains": "UserAssigned"
      },
      {
        "field": "identity.userAssignedIdentities",
        "containsKey": "[]"
      }
    ]
  },
  "then": {
    "effect": "[parameters('effect')]",
    "details": {
      "type": "[concat(parameters('resourceType'), '/extensions')]",
      "roleDefinitionIds": [
        "/providers/microsoft.authorization/roleDefinitions/9980e02c-c2be-4d73-94e8-173b1dc7cf3c"
      ],
      "existenceCondition": {
        "allOf": [
          {
            "field": "[concat(parameters('resourceType'), '/extensions/type')]",
            "equals": "[if(equals(parameters('osType'), 'Windows'), 'AzureMonitorWindowsAgent', 'AzureMonitorLinuxAgent')]"
          },
          {
            "field": "[concat(parameters('resourceType'), '/extensions/publisher')]",
            "equals": "Microsoft.Azure.Monitor"
          },
          {
            "field": "[concat(parameters('resourceType'), '/extensions/provisioningState')]",
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
              "resourceType": "[parameters('resourceType')]"
            },
            "resources": [
              {
                "name": "[concat(parameters('vmName'), '/AzureMonitorAgent')]",
                "type": "[concat(variables('resourceType'), '/extensions')]",
                "location": "[parameters('location')]",
                "apiVersion": "2019-07-01",
                "properties": {
                  "publisher": "Microsoft.Azure.Monitor",
                  "type": "[if(equals(parameters('osType'), 'Windows'), 'AzureMonitorWindowsAgent', 'AzureMonitorLinuxAgent')]",
                  "typeHandlerVersion": "[if(equals(parameters('osType'), 'Windows'), '1.8', '1.22')]",
                  "autoUpgradeMinorVersion": true,
                  "enableAutomaticUpgrade": true
                }
              }
            ]
          },
          "parameters": {
            "vmName": {
              "value": "[field('name')]"
            },
            "location": {
              "value": "[field('location')]"
            },
            "osType": {
              "value": "[if(equals(parameters('resourceType'), 'Microsoft.Compute/virtualMachines'), field('storageProfile.osDisk.osType'), field('virtualMachineProfile.storageProfile.osDisk.osType'))]"
            }
          }
        }
      }
    }
  }
}
POLICY_RULE

  # language=json
  parameters = <<PARAMETERS
  {
    "effect": {
      "type": "String",
      "metadata": {
        "displayName": "Effect",
        "description": "Enable or disable the execution of the policy"
      },
      "allowedValues": [
        "DeployIfNotExists",
        "Disabled"
      ],
      "defaultValue": "DeployIfNotExists"
    },
    "osType": {
      "type": "String",
      "metadata": {
        "displayName": "OS Type",
        "description": "Windows or Linux."
      },
      "allowedValues": [
        "Windows",
        "Linux"
      ]
    },
    "resourceType": {
      "type": "String",
      "metadata": {
        "displayName": "Ressource Type",
        "description": "VM or VMSS."
      },
      "allowedValues": [
        "Microsoft.Compute/virtualMachines",
        "Microsoft.Compute/virtualMachineScaleSets"
      ]
    },
    "userAssignedManagedIdentity": {
      "type": "String",
      "metadata": {
        "displayName": "User-Assigned Managed Identity",
        "description": "The id of the user-assigned managed identity which Azure Monitor Agent will use for authentication."
      }
    }
  }
PARAMETERS
}
