# ref: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_profile
resource "azurerm_network_profile" "aci_profile" {
  name                = "netprof-cshell-aci"
  location            = azurerm_resource_group.jok-default.location
  resource_group_name = azurerm_resource_group.jok-default.name

  container_network_interface {
    name = "eth-${azurerm_subnet.aci.name}"

    ip_configuration {
      name      = "ipconfig-${azurerm_subnet.aci.name}"
      subnet_id = azurerm_subnet.aci.id
    }
  }
}

# ref: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/relay_namespace
resource "azurerm_relay_namespace" "relay" {
  name                = "jok-cshell-relay"
  location            = azurerm_resource_group.jok-default.location
  resource_group_name = azurerm_resource_group.jok-default.name
  sku_name            = "Standard"
}

# ref: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint
resource "azurerm_private_endpoint" "relay_endpoint" {
  name                = "pe-${azurerm_relay_namespace.relay.name}"
  location            = azurerm_resource_group.jok-default.location
  resource_group_name = azurerm_resource_group.jok-default.name
  subnet_id           = azurerm_subnet.jok-default.id

  private_service_connection {
    name                           = "psc-${azurerm_relay_namespace.relay.name}"
    private_connection_resource_id = azurerm_relay_namespace.relay.id
    is_manual_connection           = false
    subresource_names              = ["namespace"]
  }
}

# ref: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone
resource "azurerm_private_dns_zone" "relay" {
  name                = "privatelink.servicebus.windows.net"
  resource_group_name = azurerm_resource_group.jok-default.name
}

# ref: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_a_record
resource "azurerm_private_dns_a_record" "relay" {
  name                = azurerm_relay_namespace.relay.name
  zone_name           = azurerm_private_dns_zone.relay.name
  resource_group_name = azurerm_private_dns_zone.relay.resource_group_name
  ttl                 = 300
  records             = azurerm_private_endpoint.relay_endpoint.private_service_connection[*].private_ip_address
}

# ref: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone_virtual_network_link
resource "azurerm_private_dns_zone_virtual_network_link" "relay" {
  name                  = azurerm_virtual_network.jok-default.name
  resource_group_name   = azurerm_private_dns_zone.relay.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.relay.name
  virtual_network_id    = azurerm_virtual_network.jok-default.id
}
