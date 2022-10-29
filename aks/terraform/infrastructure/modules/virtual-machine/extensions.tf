resource "azurerm_virtual_machine_extension" "AzureMonitorAgent" {
  name      = "AzureMonitorAgent"
  publisher = "Microsoft.Azure.Monitor"
  type      = var.type == "linux" ? "AzureMonitorLinuxAgent" : "AzureMonitorWindowsAgent"
  # https://learn.microsoft.com/en-us/azure/azure-monitor/agents/azure-monitor-agent-extension-versions
  type_handler_version       = var.type == "linux" ? "1.22" : "1.8"
  auto_upgrade_minor_version = true
  automatic_upgrade_enabled  = true

  virtual_machine_id = local.virtual_machine_id
}

moved {
  from = azurerm_virtual_machine_extension.AzureMonitorLinuxAgent
  to   = azurerm_virtual_machine_extension.AzureMonitorAgent
}
