resource "azurerm_storage_account" "bootdiag" {
  name                     = "jokmspbootdiag"
  location                 = azurerm_resource_group.default.location
  resource_group_name      = azurerm_resource_group.default.name
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

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

resource "azurerm_linux_virtual_machine" "bastion" {
  name                = "bastion"
  resource_group_name = azurerm_resource_group.default.name
  location            = azurerm_resource_group.default.location

  admin_username = "adminuser"

  admin_ssh_key {
    username   = "adminuser"
    public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCpNmPcScu9AHK6aAVCc5+hxTlv34e1vzyS+1kbbRxOX7XUQ19ko/tSh5xfn2ZySgML6vtRXmJ7vjZ9N6YAgQQ8eSwGDgR9+AJBv0OmPPiPQ9b6XjDS0EC3QOc+PxNIAv/A42TLjJzKq/BSaEPl1B2XA5eyi5TnW+CzijaT9bBrIM3KFGLCAGhGj5uwd0c995VUBjAet4m6bJ2tzvC/BdeMkz+Q2ASU6f0LNm2a6u1q620140Cr3b8vL9UKk9/pUCLYJVBv71ZB5G4KBnhBdL6ZgkQvBDPRDzpWqiUMdZXyuhfWcLrlQdLwvd0+rG9xm6/ZQEHXDR6xbj/X9fn9Yoyv"
  }

  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.bootdiag.primary_blob_endpoint
  }

  disable_password_authentication = true

  network_interface_ids = [
    azurerm_network_interface.bastion.id,
  ]

  size = "Standard_B1ms"

  os_disk {
    caching                  = "ReadWrite"
    disk_size_gb             = 50
    name                     = "bastion-root"
    storage_account_type     = "Standard_LRS"
  }

  source_image_reference {
    offer                 = "0001-com-ubuntu-server-focal"
    publisher             = "Canonical"
    sku                   = "20_04-lts-gen2"
    version               = "latest"
  }

  patch_mode          = "AutomaticByPlatform"
  provision_vm_agent  = true
  secure_boot_enabled = true
  vtpm_enabled        = true
}

resource "azurerm_virtual_machine_extension" "AzureMonitorLinuxAgent" {
  name                       = "AzureMonitorLinuxAgent"
  publisher                  = "Microsoft.Azure.Monitor"
  type                       = "AzureMonitorLinuxAgent"
  type_handler_version       = "1.21"
  auto_upgrade_minor_version = "true"

  virtual_machine_id = azurerm_linux_virtual_machine.bastion.id
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
