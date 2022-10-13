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
