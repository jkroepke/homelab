locals {
  virtual_machine_id = try(azurerm_linux_virtual_machine.this[0].id, azurerm_windows_virtual_machine.this[0].id)
}

moved {
  from = azurerm_linux_virtual_machine.bastion
  to   = azurerm_linux_virtual_machine.this[0]
}
