resource "azurerm_policy_definition" "vmss-vm-insights" {
  name         = "vmss-vm-insights"
  policy_type  = "Custom"
  mode         = "Indexed"
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
        "effect": "[parameters('effect')]",
        "details": {
          "type": "Microsoft.Compute/virtualMachineScaleSets/extensions",
          "roleDefinitionIds": [
            "/providers/microsoft.authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
          ],
          "existenceCondition": {
            "allOf": [
              {
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
              {
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
                "resourceGroup": {
                  "value": "[resourceGroup().name]"
                },
                "userAssignedManagedIdentity": {
                  "value": "[parameters('userAssignedManagedIdentity')]"
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
                  }
                },
                "variables": {
                  "extensionName": "AzureMonitorLinuxAgent",
                  "extensionPublisher": "Microsoft.Azure.Monitor",
                  "extensionType": "AzureMonitorLinuxAgent",
                  "extensionTypeHandlerVersion": "1.21",

                  "subscriptionId": "[subscription().subscriptionId]",
                  "dcraName": "[concat(parameters('vmName'), '/Microsoft.Insights/VMInsights-Dcr-Association')]",
                  "dcraDeployment": "[concat('dcraDeployment-', uniqueString(deployment().name))]"
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
                  },
                  {
                    "name": "[variables('dcraDeployment')]",
                    "type": "Microsoft.Resources/deployments",
                    "dependsOn": [
                      "[concat(parameters('vmName'), '/', variables('extensionName'))]"
                    ],
                    "apiVersion": "2020-06-01",
                    "resourceGroup": "[parameters('resourceGroup')]",
                    "properties": {
                      "mode": "Incremental",
                      "expressionEvaluationOptions": {
                        "scope": "inner"
                      },
                      "parameters": {
                        "vmName": {
                          "value": "[parameters('vmName')]"
                        },
                        "dataCollectionRuleId": {
                          "value": "[parameters('dataCollectionRuleId')]"
                        },
                        "dcraName": {
                          "value": "[variables('dcraName')]"
                        }
                      },
                      "template": {
                        "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
                        "contentVersion": "1.0.0.0",
                        "parameters": {
                          "vmName": {
                            "type": "string"
                          },
                          "dcrId": {
                            "type": "string"
                          },
                          "dcraName": {
                            "type": "string"
                          }
                        },
                        "variables": {},
                        "resources": [
                          {
                            "type": "Microsoft.Compute/virtualMachineScaleSets/providers/dataCollectionRuleAssociations",
                            "name": "[parameters('dcraName')]",
                            "apiVersion": "2019-11-01-preview",
                            "properties": {
                              "description": "Association of data collection rule for VMInsights. Deleting this association will stop the insights flow for this virtual machine.",
                              "dataCollectionRuleId": "[parameters('dataCollectionRuleId')]"
                            }
                          }
                        ]
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

resource "azurerm_subscription_policy_assignment" "vmss-vm-insights" {
  name                 = "vmss-vm-insights"
  policy_definition_id = azurerm_policy_definition.vmss-vm-insights.id
  subscription_id      = data.azurerm_subscription.current.id

  location = azurerm_resource_group.default.location

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.policy-azure-monitor.id]
  }

  parameters = jsonencode({
    "userAssignedManagedIdentity": {
      "value": azurerm_user_assigned_identity.aks-kubelet.id,
    },
    "dataCollectionRuleId": {
      "value": azurerm_monitor_data_collection_rule.vminsights.id,
    }
  })

  depends_on = [
    azurerm_role_assignment.mi-policy-azure-monitor-contributor
  ]
}
