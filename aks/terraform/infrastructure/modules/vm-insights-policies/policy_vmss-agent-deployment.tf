resource "azurerm_policy_definition" "opsstack-vm-insights-deploy-agent-vmss" {
  name         = "opsstack-vm-insights-deploy-agent-vmss"
  policy_type  = "Custom"
  mode         = "Indexed"
  display_name = "Ops.Stack VMInsights: Deploy Azure Monitor Agent on VMSSs"

  metadata = jsonencode({ category : "Ops.Stack" })

  policy_rule = file("${path.module}/policies/agent-deployment-vmss.json")

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
    }
  }
PARAMETERS
}
