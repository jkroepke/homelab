

resource "azurerm_policy_definition" "vmss-vm-insights-extension" {
  name         = "vmss-vm-insights-extension"
  policy_type  = "Custom"
  mode         = "Indexed"
  display_name = "Enable vmss insights on AKS nodes (VMExtension)"

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
        "effect": "[parameters('effect')]",
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
              "parameters": {
                "vmName": {
                  "value": "[field('name')]"
                },
                "location": {
                  "value": "[field('location')]"
                },
                "resourceGroup": {
                  "value": "[resourceGroup().name]"
                },
                "userAssignedManagedIdentity": {
                  "value": "[parameters('userAssignedManagedIdentity')]"
                }
              },
              "template": {
                "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                "contentVersion": "1.0.0.0",
                "parameters": {
                  "vmName": {
                    "type": "string"
                  },
                  "location": {
                    "type": "string"
                  },
                  "resourceGroup": {
                    "type": "string"
                  },
                  "userAssignedManagedIdentity": {
                    "type": "string"
                  }
                },
                "variables": {
                  "extensionName": "AzureMonitorLinuxAgent",
                  "extensionPublisher": "Microsoft.Azure.Monitor",
                  "extensionType": "AzureMonitorLinuxAgent",
                  "extensionTypeHandlerVersion": "1.22"
                },
                "resources": [
                  {
                    "name": "[concat(parameters('vmName'), '/', variables('extensionName'))]",
                    "type": "Microsoft.Compute/virtualMachineScaleSets/extensions",
                    "location": "[parameters('location')]",
                    "apiVersion": "2021-04-01",
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

resource "azurerm_policy_definition" "vmss-vm-insights-dcra" {
  name         = "vmss-vm-insights-dcra"
  policy_type  = "Custom"
  mode         = "Indexed"
  display_name = "Enable vmss insights on AKS nodes (DCRA)"

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
        "effect": "[parameters('effect')]",
        "details": {
          "type": "Microsoft.Insights/dataCollectionRuleAssociations",
          "roleDefinitionIds": [
            "/providers/microsoft.authorization/roleDefinitions/749f88d5-cbae-40b8-bcfc-e573ddc772fa"
          ],
          "existenceCondition": {
            "allOf": [
              {
                "field": "Microsoft.Insights/dataCollectionRuleAssociations/dataCollectionRuleId",
                "equals": "[parameters('dataCollectionRuleId')]"
              },
              {
                "field": "name",
                "equals": "VMInsights-Dcr-Association"
              }
            ]
          },
          "deployment": {
            "properties": {
              "mode": "incremental",
              "parameters": {
                "vmName": {
                  "value": "[field('name')]"
                },
                "location": {
                  "value": "[field('location')]"
                },
                "resourceGroup": {
                  "value": "[resourceGroup().name]"
                },
                "dataCollectionRuleId": {
                  "value": "[parameters('dataCollectionRuleId')]"
                }
              },
              "template": {
                "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                "contentVersion": "1.0.0.0",
                "parameters": {
                  "vmName": {
                    "type": "string"
                  },
                  "location": {
                    "type": "string"
                  },
                  "resourceGroup": {
                    "type": "string"
                  },
                  "dataCollectionRuleId": {
                    "type": "string"
                  }
                },
                "variables": {
                  "subscriptionId": "[subscription().subscriptionId]",
                  "dcraName": "[concat('assoc-', uniqueString(parameters('dataCollectionRuleId')))]",
                  "dcraDeployment": "[concat('dcraDeployment-', uniqueString(deployment().name))]"
                },
                "resources": [
                  {
                    "name": "[variables('dcraName')]",
                    "type": "Microsoft.Insights/dataCollectionRuleAssociations",
                    "apiVersion": "2021-04-01",
                    "properties": {
                      "dataCollectionRuleId": "[parameters('dataCollectionRuleId')]"
                    },
                    "scope": "[concat('Microsoft.Compute/virtualMachineScaleSets/', parameters('vmName'))]"
                  }
                ]
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
    "dataCollectionRuleId": {
      "type": "String",
      "metadata": {
        "displayName": "Id of the Data Collection Rule(DCR)"
      }
    }
  }
PARAMETERS
}

resource "azurerm_subscription_policy_assignment" "vmss-vm-insights-extension" {
  name                 = "vmss-vm-insights-extension"
  policy_definition_id = azurerm_policy_definition.vmss-vm-insights-extension.id
  subscription_id      = data.azurerm_subscription.current.id

  location = azurerm_resource_group.default.location

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.policy-azure-monitor.id]
  }

  parameters = jsonencode({
    "userAssignedManagedIdentity" : {
      "value" : azurerm_user_assigned_identity.aks-kubelet.id,
    }
  })

  depends_on = [
    azurerm_role_assignment.mi-policy-monitoring-contributor,
    azurerm_role_assignment.mi-policy-azure-monitor-virtual-machine-contributor,
  ]
}

resource "azurerm_subscription_policy_assignment" "vmss-vm-insights-dcra" {
  name                 = "vmss-vm-insights-dcra"
  policy_definition_id = azurerm_policy_definition.vmss-vm-insights-dcra.id
  subscription_id      = data.azurerm_subscription.current.id

  location = azurerm_resource_group.default.location

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.policy-azure-monitor.id]
  }

  parameters = jsonencode({
    "dataCollectionRuleId" : {
      "value" : azurerm_monitor_data_collection_rule.vminsights.id,
    }
  })

  depends_on = [
    azurerm_role_assignment.mi-policy-monitoring-contributor,
    azurerm_role_assignment.mi-policy-azure-monitor-virtual-machine-contributor,
  ]
}
