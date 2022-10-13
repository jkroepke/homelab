resource "azurerm_log_analytics_workspace" "default" {
  name                = "default"
  location            = azurerm_resource_group.default.location
  resource_group_name = azurerm_resource_group.default.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

/*
resource "azurerm_log_analytics_solution" "vminsights" {
  solution_name         = "VMInsights"
  location              = azurerm_log_analytics_workspace.default.location
  resource_group_name   = azurerm_log_analytics_workspace.default.resource_group_name
  workspace_resource_id = azurerm_log_analytics_workspace.default.id
  workspace_name        = azurerm_log_analytics_workspace.default.name

  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/VMInsights"
  }
}
*/

resource "azurerm_monitor_data_collection_rule" "vminsights" {
  name                = "VMInsights"
  resource_group_name = azurerm_resource_group.default.name
  location            = azurerm_resource_group.default.location

  destinations {
    azure_monitor_metrics {
      name = "metrics"
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

resource "azurerm_monitor_data_collection_rule_association" "bastionvminsights" {
  name                    = "bastion"
  target_resource_id      = module.bastion.vm_id
  data_collection_rule_id = azurerm_monitor_data_collection_rule.vminsights.id
}
