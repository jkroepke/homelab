resource "azurerm_policy_definition" "opsstack-system-assigned-managed-identity" {
  name         = "opsstack-system-assigned-managed-identity"
  policy_type  = "Custom"
  mode         = "Indexed"
  display_name = "Ops.Stack VMInsights: Configure system-assigned managed identity on VMs and VMSSs"

  metadata = jsonencode({ category : "Ops.Stack" })

  policy_rule = file("${path.module}/policies/system-assigned-managed-identity.json")

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
        "Modify",
        "Disabled"
      ],
      "defaultValue": "Modify"
    }
  }
PARAMETERS
}
