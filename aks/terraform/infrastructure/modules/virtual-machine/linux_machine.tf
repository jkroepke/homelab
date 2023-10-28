
# https://learn.microsoft.com/en-us/azure/azure-monitor/agents/azure-monitor-agent-manage?tabs=ARMAgentPowerShell%2CPowerShellWindows%2CPowerShellWindowsArc%2CCLIWindows%2CCLIWindowsArc#prerequisites
resource "azurerm_linux_virtual_machine" "this" {
  count = var.type == "linux" ? 1 : 0

  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location

  admin_username = "adminuser"

  admin_ssh_key {
    username   = "adminuser"
    public_key = var.public_key
  }

  boot_diagnostics {
    storage_account_uri = null
  }

  disable_password_authentication = true

  network_interface_ids = [
    azurerm_network_interface.this.id,
  ]

  size = var.size

  os_disk {
    caching              = "ReadWrite"
    disk_size_gb         = 50
    name                 = "${var.name}-root"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    offer     = "0001-com-ubuntu-server-focal"
    publisher = "Canonical"
    sku       = "20_04-lts-gen2"
    version   = "latest"
  }

  patch_mode          = "AutomaticByPlatform"
  provision_vm_agent  = true
  secure_boot_enabled = true
  vtpm_enabled        = true

  # For Azure Monitor
  identity {
    type = "SystemAssigned"
  }

  tags = {
    "opsstack-cpu-critical"        = "93"
    "opsstack-cpu-warning"         = "81"
    "opsstack-disk-critical-C:"    = "88"
    "opsstack-disk-warning-C:"     = "87"
    "opsstack-disk-critical-D:"    = "89"
    "opsstack-disk-critical-|"     = "3"
    "opsstack-disk-critical-|mnt|" = "15"
    "opsstack-memory-critical"     = "3"
    "opsstack-memory-warning"      = "15"
  }

  lifecycle {
    ignore_changes = [tags]
  }
}
