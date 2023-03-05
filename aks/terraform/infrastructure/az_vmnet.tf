resource "azurerm_virtual_network" "jok-default" {
  name                = "jok-default"
  location            = azurerm_resource_group.jok-default.location
  resource_group_name = azurerm_resource_group.jok-default.name
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "jok-aks-api" {
  name                 = "jok-aks-api"
  resource_group_name  = azurerm_resource_group.jok-default.name
  virtual_network_name = azurerm_virtual_network.jok-default.name
  address_prefixes     = ["10.0.0.0/28"]

  delegation {
    name = "aks-delegation"
    service_delegation {
      name = "Microsoft.ContainerService/managedClusters"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action"
      ]
    }
  }
}

resource "azurerm_subnet" "aci" {
  name                 = "jok-cshell-aci"
  resource_group_name  = azurerm_resource_group.jok-default.name
  virtual_network_name = azurerm_virtual_network.jok-default.name
  address_prefixes     = ["10.0.0.16/28"]

  delegation {
    name = "CloudShellDelegation"

    service_delegation {
      name = "Microsoft.ContainerInstance/containerGroups"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/action"
      ]
    }
  }

  service_endpoints = ["Microsoft.Storage"]
}

resource "azurerm_subnet" "jok-aks-pods" {
  name                 = "jok-aks-pods"
  resource_group_name  = azurerm_resource_group.jok-default.name
  virtual_network_name = azurerm_virtual_network.jok-default.name
  address_prefixes     = ["10.0.128.0/18"]

  /*
  delegation {
    name = "aks-delegation"

    service_delegation {
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
      ]
      name = "Microsoft.ContainerService/managedClusters"
    }
  }
  */
}

resource "azurerm_subnet" "jok-default" {
  name                 = "jok-default"
  resource_group_name  = azurerm_resource_group.jok-default.name
  virtual_network_name = azurerm_virtual_network.jok-default.name
  address_prefixes     = ["10.0.192.0/18"]
}
