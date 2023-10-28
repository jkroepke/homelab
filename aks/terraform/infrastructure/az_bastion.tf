module "bastion_linux" {
  source = "./modules/virtual-machine"

  name                                 = "bastion-linux"
  resource_group_name                  = azurerm_resource_group.jok-default.name
  location                             = azurerm_resource_group.jok-default.location
  subnet_id                            = azurerm_subnet.jok-default.id
  dns_zone_name                        = data.azurerm_dns_zone.aks_jkroepke_de.name
  dns_resource_group_name              = data.azurerm_dns_zone.aks_jkroepke_de.resource_group_name
  public_key                           = local.public_key
  type                                 = "linux"

  enable_public_interface = true
}

module "bastion_windows" {
  source = "./modules/virtual-machine"

  name                                 = "bastion-win"
  resource_group_name                  = azurerm_resource_group.jok-default.name
  location                             = azurerm_resource_group.jok-default.location
  subnet_id                            = azurerm_subnet.jok-default.id
  dns_zone_name                        = data.azurerm_dns_zone.aks_jkroepke_de.name
  dns_resource_group_name              = data.azurerm_dns_zone.aks_jkroepke_de.resource_group_name
  public_key                           = local.public_key
  type                                 = "windows"

  enable_public_interface = true
}

resource "azurerm_virtual_machine_extension" "hostname" {
  name                 = "hostname"
  virtual_machine_id   = module.bastion_linux.vm_id
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.1"

  settings = <<SETTINGS
 {
  "commandToExecute": "hostname && uptime"
 }
SETTINGS
}

resource "azurerm_virtual_machine_extension" "hostname2" {
  count = 0

  name                 = "hostname2"
  virtual_machine_id   = module.bastion_linux.vm_id
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.1"

  settings = <<SETTINGS
 {
  "commandToExecute": "hostname && uptime"
 }
SETTINGS
}
