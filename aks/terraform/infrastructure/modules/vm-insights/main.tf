resource "azurerm_policy_set_definition" "tag_governance" {
  name         = "vm-insights"
  policy_type  = "Custom"
  display_name = "Enable VMInsights"
  description  = "Enable VMInsights on all VM/VMSS"

  metadata = jsonencode({
    "category": "Monitoring"
  })

  dynamic "policy_definition_reference" {
    for_each = azurerm_policy_definition.addTagToRG
    content {
      policy_definition_id = policy_definition_reference.value.id
      reference_id         = policy_definition_reference.value.id
    }
  }
}
