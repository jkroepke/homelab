resource "azurerm_policy_definition" "opsstack-vm-insights-data-collection-rule-association" {
  name         = "opsstack-vm-insights-data-collection-rule-association"
  policy_type  = "Custom"
  mode         = "Indexed"
  display_name = "Ops.Stack VMInsights: Associate data collection rule"

  metadata = jsonencode({ category : "Ops.Stack" })

  policy_rule = file("${path.module}/policies/data-collection-rule-association.json")

  # language=json
  parameters = <<PARAMETERS
  {
    "effect": {
      "type": "String",
      "metadata": {
        "displayName": "Effect",
        "description": "Enable or disable the execution of the policy."
      },
      "allowedValues": [
        "DeployIfNotExists",
        "Disabled"
      ],
      "defaultValue": "DeployIfNotExists"
    },
    "dcrResourceId": {
      "type": "String",
      "metadata": {
        "displayName": "Data Collection Rule Resource Id",
        "description": "Resource Id of the Data Collection Rule to be applied on the virtual machines in scope."
      }
    }
  }
PARAMETERS
}
