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
    destinations = ["metrics", "law"]
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

resource "azurerm_monitor_data_collection_rule_association" "bastionvminsights" {
  name                    = "bastion"
  target_resource_id      = module.bastion.vm_id
  data_collection_rule_id = azurerm_monitor_data_collection_rule.vminsights.id
}

resource "azurerm_monitor_data_collection_rule_association" "bastionwinvminsights" {
  name                    = "bastion-win"
  target_resource_id      = module.bastion_windows.vm_id
  data_collection_rule_id = azurerm_monitor_data_collection_rule.vminsights.id
}
