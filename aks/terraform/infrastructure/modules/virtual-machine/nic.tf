resource "azurerm_public_ip" "this" {
  for_each = toset(var.enable_public_interface ? ["4"] : [])

  name                = "${var.name}${each.key}"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  ip_version          = "IPv${each.key}"
  sku                 = "Basic"

  # https://github.com/hashicorp/terraform-provider-azurerm/issues/15483
  lifecycle {
    create_before_destroy = true
  }
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
    public_ip_address_id          = try(azurerm_public_ip.this["4"].id, null)
    primary                       = true
  }
}

resource "azurerm_network_interface_security_group_association" "default" {
  count = var.enable_public_interface ? 1 : 0

  network_interface_id      = azurerm_network_interface.this.id
  network_security_group_id = azurerm_network_security_group.this.id
}

resource "azurerm_network_security_group" "this" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name

  dynamic "security_rule" {
    for_each = toset(var.enable_public_interface ? [true] : [])
    content {
      name                       = "ALLOW_INSECURE_PORTS"
      priority                   = 100
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_ranges    = ["22", "3389", "5985", "5986"]
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }
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
