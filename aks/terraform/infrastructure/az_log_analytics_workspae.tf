resource "azurerm_monitor_diagnostic_setting" "aks-metrics" {
  name                       = "AllMetrics"
  target_resource_id         = azurerm_kubernetes_cluster.jok.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.default.id

  log {
    category = "cloud-controller-manager"
    enabled  = false

    retention_policy {
      days    = 0
      enabled = false
    }
  }
  log {
    category = "cluster-autoscaler"
    enabled  = false

    retention_policy {
      days    = 0
      enabled = false
    }
  }
  log {
    category = "csi-azuredisk-controller"
    enabled  = false

    retention_policy {
      days    = 0
      enabled = false
    }
  }
  log {
    category = "csi-azurefile-controller"
    enabled  = false

    retention_policy {
      days    = 0
      enabled = false
    }
  }
  log {
    category = "csi-snapshot-controller"
    enabled  = false

    retention_policy {
      days    = 0
      enabled = false
    }
  }
  log {
    category = "guard"
    enabled  = false

    retention_policy {
      days    = 0
      enabled = false
    }
  }
  log {
    category = "kube-apiserver"
    enabled  = false

    retention_policy {
      days    = 0
      enabled = false
    }
  }
  log {
    category = "kube-audit"
    enabled  = false

    retention_policy {
      days    = 0
      enabled = false
    }
  }
  log {
    category = "kube-audit-admin"
    enabled  = false

    retention_policy {
      days    = 0
      enabled = false
    }
  }
  log {
    category = "kube-controller-manager"
    enabled  = false

    retention_policy {
      days    = 0
      enabled = false
    }
  }
  log {
    category = "kube-scheduler"
    enabled  = false

    retention_policy {
      days    = 0
      enabled = false
    }
  }


  metric {
    category = "AllMetrics"

    retention_policy {
      enabled = true
    }
  }
}

resource "azurerm_log_analytics_workspace" "default" {
  name                = "default"
  location            = azurerm_resource_group.default.location
  resource_group_name = azurerm_resource_group.default.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

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

resource "azurerm_monitor_data_collection_rule" "vminsights" {
  name                = "VMInsights"
  resource_group_name = azurerm_resource_group.default.name
  location            = azurerm_resource_group.default.location

  destinations {
    log_analytics {
      workspace_resource_id = azurerm_log_analytics_workspace.default.id
      name                  = "log-analytics"
    }

    azure_monitor_metrics {
      name = "metrics"
    }
  }

  data_flow {
    streams      = ["Microsoft-InsightsMetrics"]
    destinations = ["metrics", "log-analytics"]
  }

  data_sources {
    performance_counter {
      streams                       = ["Microsoft-InsightsMetrics"]
      sampling_frequency_in_seconds = 60
      counter_specifiers            = ["\\VmInsights\\DetailedMetrics"]
      name                          = "VMInsightsPerfCounters"
    }
  }

  depends_on = [
    azurerm_log_analytics_solution.vminsights
  ]
}

resource "azurerm_monitor_data_collection_rule_association" "bastionvminsights" {
  name                    = azurerm_linux_virtual_machine.bastion.name
  target_resource_id      = azurerm_linux_virtual_machine.bastion.id
  data_collection_rule_id = azurerm_monitor_data_collection_rule.vminsights.id
}
