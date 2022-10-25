resource "azurerm_windows_virtual_machine" "this" {
  count = var.type == "windows" ? 1 : 0

  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location

  admin_username      = "adminuser"
  admin_password      = coalesce(random_string.password.result, "")

  network_interface_ids = [
    azurerm_network_interface.this.id,
  ]

  boot_diagnostics {
    storage_account_uri = var.boot_diagnostics_storage_account_uri
  }

  os_disk {
    caching              = "ReadWrite"
    disk_size_gb         = 50
    name                 = "${var.name}-root"
    storage_account_type = "Standard_LRS"
  }

  size                = "Standard_B1ms"

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-datacenter-smalldisk-g2"
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
}

resource "random_string" "password" {
  length = 16

  special = false
}
