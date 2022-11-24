resource "azurerm_monitor_data_collection_rule" "vminsights" {
  name                = "VMInsights"
  resource_group_name = azurerm_resource_group.default.name
  location            = azurerm_resource_group.default.location

  destinations {
    azure_monitor_metrics {
      name = "metrics"
    }

    log_analytics {
      workspace_resource_id = azurerm_log_analytics_workspace.default.id
      name                  = "law"
    }
  }

  data_flow {
    streams      = ["Microsoft-InsightsMetrics"]
    destinations = ["metrics"]
  }

  data_sources {
    performance_counter {
      streams                       = ["Microsoft-InsightsMetrics"]
      sampling_frequency_in_seconds = 60
      counter_specifiers            = ["\\VmInsights\\DetailedMetrics"]
      name                          = "VMInsightsPerfCounters"
    }
  }
}

module "vm-insights-policies" {
  source = "./modules/vm-insights-policies"
}

resource "azurerm_user_assigned_identity" "policy-azure-monitor" {
  name                = "policy-azure-monitor"
  resource_group_name = azurerm_resource_group.default.name
  location            = azurerm_resource_group.default.location
}

resource "azurerm_role_assignment" "policy-azure-monitor" {
  for_each = toset([
    "Managed Identity Contributor",
    "Managed Identity Operator",
    "Virtual Machine Contributor",
    "Monitoring Contributor",
    "Log Analytics Contributor"
  ])

  scope                = data.azurerm_subscription.current.id
  role_definition_name = each.key
  principal_id         = azurerm_user_assigned_identity.policy-azure-monitor.principal_id
}

resource "azurerm_subscription_policy_assignment" "vm-insights" {
  name         = "opsstack-enable-vminsights"
  display_name = "Ops.Stack - Enable VMInsights"

  description = "This policy definition enables VMInsights and dependencies on all VMs and VMSSs"

  policy_definition_id = module.vm-insights-policies.policy_set_id
  subscription_id      = data.azurerm_subscription.current.id

  parameters = jsonencode({
    dcrResourceId = {
      value = azurerm_monitor_data_collection_rule.vminsights.id
    }
  })

  location = azurerm_resource_group.default.location

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.policy-azure-monitor.id]
  }

  depends_on = [azurerm_role_assignment.policy-azure-monitor]
}
