data "azurerm_resource_group" "default" {
  name = "default"
}

resource "azurerm_virtual_network" "default" {
  name                = "default"
  location            = data.azurerm_resource_group.default.location
  resource_group_name = data.azurerm_resource_group.default.name
  address_space       = ["10.0.0.0/16", "fd00:db8:deca::/48"]
}

resource "azurerm_subnet" "default" {
  name                 = "default"
  resource_group_name  = data.azurerm_resource_group.default.name
  virtual_network_name = azurerm_virtual_network.default.name
  address_prefixes     = ["10.0.0.0/16", "fd00:db8:deca::/64"]
}