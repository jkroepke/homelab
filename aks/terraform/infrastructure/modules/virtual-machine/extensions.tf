resource "azurerm_virtual_machine_extension" "AzureMonitorLinuxAgent" {
  name                       = "AzureMonitorLinuxAgent"
  publisher                  = "Microsoft.Azure.Monitor"
  type                       = "AzureMonitorLinuxAgent"
  # https://learn.microsoft.com/en-us/azure/azure-monitor/agents/azure-monitor-agent-extension-versions
  type_handler_version       = "1.22"
  auto_upgrade_minor_version = true
  automatic_upgrade_enabled  = true

  virtual_machine_id = azurerm_linux_virtual_machine.bastion.id
}
