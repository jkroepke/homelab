resource "azurerm_policy_set_definition" "opsstack-vm-insights" {
  name         = "opsstack-vm-insights"
  policy_type  = "Custom"
  display_name = "Ops.Stack: VMInsights"

  metadata = jsonencode({ category : "Ops.Stack" })

  parameters = <<PARAMETERS
    {
      "dcrResourceId": {
        "type": "String",
        "metadata": {
          "description": "Data Collection Rule for Monitoring Agent",
          "displayName": "Data Collection Rule for Monitoring Agent"
        }
      }
    }
PARAMETERS

  # policy_definition_reference {
  #   # [Preview]: Configure system-assigned managed identity to enable Azure Monitor assignments on VMs
  #   policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/17b3de92-f710-4cf4-aa55-0e7859f1ed7b"
  # }

  policy_definition_reference {
    policy_definition_id = azurerm_policy_definition.opsstack-system-assigned-managed-identity.id
  }

  policy_definition_reference {
    policy_definition_id = azurerm_policy_definition.opsstack-vm-insights-deploy-agent-vm.id
  }

  policy_definition_reference {
    policy_definition_id = azurerm_policy_definition.opsstack-vm-insights-deploy-agent-vmss.id
  }

  policy_definition_reference {
    policy_definition_id = azurerm_policy_definition.opsstack-vm-insights-data-collection-rule-association.id
    # language=json
    parameter_values = <<VALUE
    {
      "dcrResourceId": {"value": "[parameters('dcrResourceId')]"}
    }
    VALUE
  }
}
