resource "azurerm_public_ip" "this" {
  for_each = toset(["4", "6"])

  name                = "${var.name}${each.key}"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  ip_version          = "IPv${each.key}"
  sku                 = "Standard"
}

resource "azurerm_network_interface" "this" {
  name                = "${var.name}-nic"
  location            = var.location
  resource_group_name = var.resource_group_name

  internal_dns_name_label = var.name

  ip_configuration {
    name                          = "${var.name}-internal4"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    private_ip_address_version    = "IPv4"
    public_ip_address_id          = azurerm_public_ip.this["4"].id
    primary                       = true
  }

  ip_configuration {
    name                          = "${var.name}-internal6"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    private_ip_address_version    = "IPv6"
    public_ip_address_id          = azurerm_public_ip.this["6"].id
    primary                       = false
  }
}

resource "azurerm_network_interface_security_group_association" "default" {
  network_interface_id      = azurerm_network_interface.this.id
  network_security_group_id = azurerm_network_security_group.this.id
}

resource "azurerm_network_security_group" "this" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name

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
