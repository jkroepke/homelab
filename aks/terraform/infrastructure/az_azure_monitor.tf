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
      name                  = "logs-law"
    }
  }

  data_flow {
    streams = [
      "Microsoft-InsightsMetrics",
    ]
    destinations = [
      "metrics", "logs-law",
    ]
  }

  data_flow {
    streams = [
      "Microsoft-Perf",
    ]
    destinations = [
      "logs-law",
    ]
  }


  data_sources {
    performance_counter {
      streams                       = ["Microsoft-Perf"]
      sampling_frequency_in_seconds = 60
      counter_specifiers            = [
        "\\Processor Information(_Total)\\% Processor Time",
        "\\Processor Information(_Total)\\% Privileged Time",
        "\\Processor Information(_Total)\\% User Time",
        "\\Processor Information(_Total)\\Processor Frequency",
        "\\System\\Processes",
        "\\Process(_Total)\\Thread Count",
        "\\Process(_Total)\\Handle Count",
        "\\System\\System Up Time",
        "\\System\\Context Switches/sec",
        "\\System\\Processor Queue Length",
        "\\Memory\\% Committed Bytes In Use",
        "\\Memory\\Available Bytes",
        "\\Memory\\Committed Bytes",
        "\\Memory\\Cache Bytes",
        "\\Memory\\Pool Paged Bytes",
        "\\Memory\\Pool Nonpaged Bytes",
        "\\Memory\\Pages/sec",
        "\\Memory\\Page Faults/sec",
        "\\Process(_Total)\\Working Set",
        "\\Process(_Total)\\Working Set - Private",
        "\\LogicalDisk(_Total)\\% Disk Time",
        "\\LogicalDisk(_Total)\\% Disk Read Time",
        "\\LogicalDisk(_Total)\\% Disk Write Time",
        "\\LogicalDisk(_Total)\\% Idle Time",
        "\\LogicalDisk(_Total)\\Disk Bytes/sec",
        "\\LogicalDisk(_Total)\\Disk Read Bytes/sec",
        "\\LogicalDisk(_Total)\\Disk Write Bytes/sec",
        "\\LogicalDisk(_Total)\\Disk Transfers/sec",
        "\\LogicalDisk(_Total)\\Disk Reads/sec",
        "\\LogicalDisk(_Total)\\Disk Writes/sec",
        "\\LogicalDisk(_Total)\\Avg. Disk sec/Transfer",
        "\\LogicalDisk(_Total)\\Avg. Disk sec/Read",
        "\\LogicalDisk(_Total)\\Avg. Disk sec/Write",
        "\\LogicalDisk(_Total)\\Avg. Disk Queue Length",
        "\\LogicalDisk(_Total)\\Avg. Disk Read Queue Length",
        "\\LogicalDisk(_Total)\\Avg. Disk Write Queue Length",
        "\\LogicalDisk(_Total)\\% Free Space",
        "\\LogicalDisk(_Total)\\Free Megabytes",
        "\\Network Interface(*)\\Bytes Total/sec",
        "\\Network Interface(*)\\Bytes Sent/sec",
        "\\Network Interface(*)\\Bytes Received/sec",
        "\\Network Interface(*)\\Packets/sec",
        "\\Network Interface(*)\\Packets Sent/sec",
        "\\Network Interface(*)\\Packets Received/sec",
        "\\Network Interface(*)\\Packets Outbound Errors",
        "\\Network Interface(*)\\Packets Received Errors",
        "\\LogicalDisk(*)\\% Free Space",
        "\\Process(explorer)\\% Processor Time",
        "\\Process(calc)\\% Processor Time",
      ]
      name                          = "VMInsightsPerfCounters"
    }

    performance_counter {
      streams                       = ["Microsoft-InsightsMetrics"]
      sampling_frequency_in_seconds = 60
      counter_specifiers            = [
        "\\VmInsights\\DetailedMetrics"
      ]
      name                          = "InsightsMetrics"
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
