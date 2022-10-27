locals {
  virtual_machine_id   = try(azurerm_linux_virtual_machine.this[0].id, azurerm_windows_virtual_machine.this[0].id)
  virtual_machine_name = try(azurerm_linux_virtual_machine.this[0].name, azurerm_windows_virtual_machine.this[0].name)
}
