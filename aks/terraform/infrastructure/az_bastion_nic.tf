resource "azurerm_public_ip" "bastion" {
  for_each = toset(["4", "6"])

  name                = "bastion${each.key}"
  location            = azurerm_resource_group.default.location
  resource_group_name = azurerm_resource_group.default.name
  allocation_method   = "Static"
  ip_version          = "IPv${each.key}"
  sku                 = "Standard"
}

resource "azurerm_dns_a_record" "bastion4" {
  name                = "bastion"
  zone_name           = azurerm_dns_zone.aks_jkroepke_de.name
  resource_group_name = azurerm_resource_group.default.name
  ttl                 = 300
  target_resource_id  = azurerm_public_ip.bastion["4"].id
}

resource "azurerm_dns_aaaa_record" "bastion6" {
  name                = "bastion"
  zone_name           = azurerm_dns_zone.aks_jkroepke_de.name
  resource_group_name = azurerm_resource_group.default.name
  ttl                 = 300
  target_resource_id  = azurerm_public_ip.bastion["6"].id
}

resource "azurerm_network_interface" "bastion" {
  name                = "bastion-nic"
  location            = azurerm_resource_group.default.location
  resource_group_name = azurerm_resource_group.default.name

  internal_dns_name_label = "bastion"

  ip_configuration {
    name                          = "internal4"
    subnet_id                     = azurerm_subnet.default.id
    private_ip_address_allocation = "Dynamic"
    private_ip_address_version    = "IPv4"
    public_ip_address_id          = azurerm_public_ip.bastion["4"].id
    primary                       = true
  }

  ip_configuration {
    name                          = "internal6"
    subnet_id                     = azurerm_subnet.default.id
    private_ip_address_allocation = "Dynamic"
    private_ip_address_version    = "IPv6"
    public_ip_address_id          = azurerm_public_ip.bastion["6"].id
    primary                       = false
  }
}

resource "azurerm_network_interface_security_group_association" "default" {
  network_interface_id      = azurerm_network_interface.bastion.id
  network_security_group_id = azurerm_network_security_group.bastion.id
}

resource "azurerm_network_security_group" "bastion" {
  name                = "bastion"
  location            = azurerm_resource_group.default.location
  resource_group_name = azurerm_resource_group.default.name

  security_rule {
    name                       = "SSH"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Internet"
    priority                   = 100
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}
