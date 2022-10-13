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
    caching              = "ReadWrite"
    disk_size_gb         = 50
    name                 = "bastion-root"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    offer     = "0001-com-ubuntu-server-focal"
    publisher = "Canonical"
    sku       = "20_04-lts-gen2"
    version   = "latest"
  }

  patch_mode          = "AutomaticByPlatform"
  provision_vm_agent  = true
  secure_boot_enabled = true
  vtpm_enabled        = true
}

# https://github.com/elongstreet88/terraform-linuxdiagnostic-agent-module/blob/master/module.tf
resource "azurerm_virtual_machine_extension" "AzureMonitorLinuxAgent" {
  name                       = "AzureMonitorLinuxAgent"
  publisher                  = "Microsoft.Azure.Monitor"
  type                       = "AzureMonitorLinuxAgent"
  type_handler_version       = "1.21"
  auto_upgrade_minor_version = "true"

  protected_settings = jsonencode({
    "workspaceKey" = azurerm_log_analytics_workspace.default.primary_shared_key
  })

  settings = jsonencode({
    "workspaceId"               = azurerm_log_analytics_workspace.default.workspace_id,
    "stopOnMultipleConnections" = true
  })

  virtual_machine_id = azurerm_linux_virtual_machine.bastion.id
}

data "azurerm_storage_account_sas" "bootdiag" {
  connection_string = azurerm_storage_account.bootdiag.primary_connection_string
  https_only        = true

  resource_types {
    service   = true
    container = true
    object    = true
  }

  services {
    blob  = true
    table = true
    queue = false
    file  = false
  }

  start  = "2000-01-01T00:00:00Z"
  expiry = "2038-12-31T00:00:00Z"

  permissions {
    read    = true
    write   = true
    delete  = true
    list    = true
    add     = true
    create  = true
    update  = true
    process = true
    filter  = true
    tag     = true
  }
}

resource "azurerm_virtual_machine_extension" "diagnostics" {
  name                       = "LinuxDiagnostic"
  virtual_machine_id         = azurerm_linux_virtual_machine.bastion.id
  publisher                  = "Microsoft.Azure.Diagnostics"
  type                       = "LinuxDiagnostic"
  type_handler_version       = "4.0"
  auto_upgrade_minor_version = "true"

  settings = jsonencode({
    "StorageAccount" = azurerm_storage_account.bootdiag.name
    "ladCfg" = {
      "diagnosticMonitorConfiguration" = {
        "eventVolume" = "Medium",
        "metrics" = {
          "metricAggregation" = [
            {
              "scheduledTransferPeriod" = "PT1H"
            },
            {
              "scheduledTransferPeriod" = "PT1M"
            }
          ],
          "resourceId" = azurerm_linux_virtual_machine.bastion.id
        },
        "performanceCounters" = jsonencode({
          "performanceCounterConfiguration" = [
            {
              "annotation" = [
                {
                  "displayName" = "Disk read guest OS",
                  "locale"      = "en-us"
                }
              ],
              "class"            = "disk",
              "condition"        = "IsAggregate=TRUE",
              "counter"          = "readbytespersecond",
              "counterSpecifier" = "/builtin/disk/readbytespersecond",
              "type"             = "builtin",
              "unit"             = "BytesPerSecond"
            },
            {
              "annotation" = [
                {
                  "displayName" = "Disk writes",
                  "locale"      = "en-us"
                }
              ],
              "class"            = "disk",
              "condition"        = "IsAggregate=TRUE",
              "counter"          = "writespersecond",
              "counterSpecifier" = "/builtin/disk/writespersecond",
              "type"             = "builtin",
              "unit"             = "CountPerSecond"
            },
            {
              "annotation" = [
                {
                  "displayName" = "Disk transfer time",
                  "locale"      = "en-us"
                }
              ],
              "class"            = "disk",
              "condition"        = "IsAggregate=TRUE",
              "counter"          = "averagetransfertime",
              "counterSpecifier" = "/builtin/disk/averagetransfertime",
              "type"             = "builtin",
              "unit"             = "Seconds"
            },
            {
              "annotation" = [
                {
                  "displayName" = "Disk transfers",
                  "locale"      = "en-us"
                }
              ],
              "class"            = "disk",
              "condition"        = "IsAggregate=TRUE",
              "counter"          = "transferspersecond",
              "counterSpecifier" = "/builtin/disk/transferspersecond",
              "type"             = "builtin",
              "unit"             = "CountPerSecond"
            },
            {
              "annotation" = [
                {
                  "displayName" = "Disk write guest OS",
                  "locale"      = "en-us"
                }
              ],
              "class"            = "disk",
              "condition"        = "IsAggregate=TRUE",
              "counter"          = "writebytespersecond",
              "counterSpecifier" = "/builtin/disk/writebytespersecond",
              "type"             = "builtin",
              "unit"             = "BytesPerSecond"
            },
            {
              "annotation" = [
                {
                  "displayName" = "Disk read time",
                  "locale"      = "en-us"
                }
              ],
              "class"            = "disk",
              "condition"        = "IsAggregate=TRUE",
              "counter"          = "averagereadtime",
              "counterSpecifier" = "/builtin/disk/averagereadtime",
              "type"             = "builtin",
              "unit"             = "Seconds"
            },
            {
              "annotation" = [
                {
                  "displayName" = "Disk write time",
                  "locale"      = "en-us"
                }
              ],
              "class"            = "disk",
              "condition"        = "IsAggregate=TRUE",
              "counter"          = "averagewritetime",
              "counterSpecifier" = "/builtin/disk/averagewritetime",
              "type"             = "builtin",
              "unit"             = "Seconds"
            },
            {
              "annotation" = [
                {
                  "displayName" = "Disk total bytes",
                  "locale"      = "en-us"
                }
              ],
              "class"            = "disk",
              "condition"        = "IsAggregate=TRUE",
              "counter"          = "bytespersecond",
              "counterSpecifier" = "/builtin/disk/bytespersecond",
              "type"             = "builtin",
              "unit"             = "BytesPerSecond"
            },
            {
              "annotation" = [
                {
                  "displayName" = "Disk reads",
                  "locale"      = "en-us"
                }
              ],
              "class"            = "disk",
              "condition"        = "IsAggregate=TRUE",
              "counter"          = "readspersecond",
              "counterSpecifier" = "/builtin/disk/readspersecond",
              "type"             = "builtin",
              "unit"             = "CountPerSecond"
            },
            {
              "annotation" = [
                {
                  "displayName" = "Disk queue length",
                  "locale"      = "en-us"
                }
              ],
              "class"            = "disk",
              "condition"        = "IsAggregate=TRUE",
              "counter"          = "averagediskqueuelength",
              "counterSpecifier" = "/builtin/disk/averagediskqueuelength",
              "type"             = "builtin",
              "unit"             = "Count"
            },
            {
              "annotation" = [
                {
                  "displayName" = "Network in guest OS",
                  "locale"      = "en-us"
                }
              ],
              "class"            = "network",
              "counter"          = "bytesreceived",
              "counterSpecifier" = "/builtin/network/bytesreceived",
              "type"             = "builtin",
              "unit"             = "Bytes"
            },
            {
              "annotation" = [
                {
                  "displayName" = "Network total bytes",
                  "locale"      = "en-us"
                }
              ],
              "class"            = "network",
              "counter"          = "bytestotal",
              "counterSpecifier" = "/builtin/network/bytestotal",
              "type"             = "builtin",
              "unit"             = "Bytes"
            },
            {
              "annotation" = [
                {
                  "displayName" = "Network out guest OS",
                  "locale"      = "en-us"
                }
              ],
              "class"            = "network",
              "counter"          = "bytestransmitted",
              "counterSpecifier" = "/builtin/network/bytestransmitted",
              "type"             = "builtin",
              "unit"             = "Bytes"
            },
            {
              "annotation" = [
                {
                  "displayName" = "Network collisions",
                  "locale"      = "en-us"
                }
              ],
              "class"            = "network",
              "counter"          = "totalcollisions",
              "counterSpecifier" = "/builtin/network/totalcollisions",
              "type"             = "builtin",
              "unit"             = "Count"
            },
            {
              "annotation" = [
                {
                  "displayName" = "Packets received errors",
                  "locale"      = "en-us"
                }
              ],
              "class"            = "network",
              "counter"          = "totalrxerrors",
              "counterSpecifier" = "/builtin/network/totalrxerrors",
              "type"             = "builtin",
              "unit"             = "Count"
            },
            {
              "annotation" = [
                {
                  "displayName" = "Packets sent",
                  "locale"      = "en-us"
                }
              ],
              "class"            = "network",
              "counter"          = "packetstransmitted",
              "counterSpecifier" = "/builtin/network/packetstransmitted",
              "type"             = "builtin",
              "unit"             = "Count"
            },
            {
              "annotation" = [
                {
                  "displayName" = "Packets received",
                  "locale"      = "en-us"
                }
              ],
              "class"            = "network",
              "counter"          = "packetsreceived",
              "counterSpecifier" = "/builtin/network/packetsreceived",
              "type"             = "builtin",
              "unit"             = "Count"
            },
            {
              "annotation" = [
                {
                  "displayName" = "Packets sent errors",
                  "locale"      = "en-us"
                }
              ],
              "class"            = "network",
              "counter"          = "totaltxerrors",
              "counterSpecifier" = "/builtin/network/totaltxerrors",
              "type"             = "builtin",
              "unit"             = "Count"
            },
            {
              "annotation" = [
                {
                  "displayName" = "Filesystem transfers/sec",
                  "locale"      = "en-us"
                }
              ],
              "class"            = "filesystem",
              "condition"        = "IsAggregate=TRUE",
              "counter"          = "transferspersecond",
              "counterSpecifier" = "/builtin/filesystem/transferspersecond",
              "type"             = "builtin",
              "unit"             = "CountPerSecond"
            },
            {
              "annotation" = [
                {
                  "displayName" = "Filesystem % free space",
                  "locale"      = "en-us"
                }
              ],
              "class"            = "filesystem",
              "condition"        = "IsAggregate=TRUE",
              "counter"          = "percentfreespace",
              "counterSpecifier" = "/builtin/filesystem/percentfreespace",
              "type"             = "builtin",
              "unit"             = "Percent"
            },
            {
              "annotation" = [
                {
                  "displayName" = "Filesystem % used space",
                  "locale"      = "en-us"
                }
              ],
              "class"            = "filesystem",
              "condition"        = "IsAggregate=TRUE",
              "counter"          = "percentusedspace",
              "counterSpecifier" = "/builtin/filesystem/percentusedspace",
              "type"             = "builtin",
              "unit"             = "Percent"
            },
            {
              "annotation" = [
                {
                  "displayName" = "Filesystem used space",
                  "locale"      = "en-us"
                }
              ],
              "class"            = "filesystem",
              "condition"        = "IsAggregate=TRUE",
              "counter"          = "usedspace",
              "counterSpecifier" = "/builtin/filesystem/usedspace",
              "type"             = "builtin",
              "unit"             = "Bytes"
            },
            {
              "annotation" = [
                {
                  "displayName" = "Filesystem read bytes/sec",
                  "locale"      = "en-us"
                }
              ],
              "class"            = "filesystem",
              "condition"        = "IsAggregate=TRUE",
              "counter"          = "bytesreadpersecond",
              "counterSpecifier" = "/builtin/filesystem/bytesreadpersecond",
              "type"             = "builtin",
              "unit"             = "CountPerSecond"
            },
            {
              "annotation" = [
                {
                  "displayName" = "Filesystem free space",
                  "locale"      = "en-us"
                }
              ],
              "class"            = "filesystem",
              "condition"        = "IsAggregate=TRUE",
              "counter"          = "freespace",
              "counterSpecifier" = "/builtin/filesystem/freespace",
              "type"             = "builtin",
              "unit"             = "Bytes"
            },
            {
              "annotation" = [
                {
                  "displayName" = "Filesystem % free inodes",
                  "locale"      = "en-us"
                }
              ],
              "class"            = "filesystem",
              "condition"        = "IsAggregate=TRUE",
              "counter"          = "percentfreeinodes",
              "counterSpecifier" = "/builtin/filesystem/percentfreeinodes",
              "type"             = "builtin",
              "unit"             = "Percent"
            },
            {
              "annotation" = [
                {
                  "displayName" = "Filesystem bytes/sec",
                  "locale"      = "en-us"
                }
              ],
              "class"            = "filesystem",
              "condition"        = "IsAggregate=TRUE",
              "counter"          = "bytespersecond",
              "counterSpecifier" = "/builtin/filesystem/bytespersecond",
              "type"             = "builtin",
              "unit"             = "BytesPerSecond"
            },
            {
              "annotation" = [
                {
                  "displayName" = "Filesystem reads/sec",
                  "locale"      = "en-us"
                }
              ],
              "class"            = "filesystem",
              "condition"        = "IsAggregate=TRUE",
              "counter"          = "readspersecond",
              "counterSpecifier" = "/builtin/filesystem/readspersecond",
              "type"             = "builtin",
              "unit"             = "CountPerSecond"
            },
            {
              "annotation" = [
                {
                  "displayName" = "Filesystem write bytes/sec",
                  "locale"      = "en-us"
                }
              ],
              "class"            = "filesystem",
              "condition"        = "IsAggregate=TRUE",
              "counter"          = "byteswrittenpersecond",
              "counterSpecifier" = "/builtin/filesystem/byteswrittenpersecond",
              "type"             = "builtin",
              "unit"             = "CountPerSecond"
            },
            {
              "annotation" = [
                {
                  "displayName" = "Filesystem writes/sec",
                  "locale"      = "en-us"
                }
              ],
              "class"            = "filesystem",
              "condition"        = "IsAggregate=TRUE",
              "counter"          = "writespersecond",
              "counterSpecifier" = "/builtin/filesystem/writespersecond",
              "type"             = "builtin",
              "unit"             = "CountPerSecond"
            },
            {
              "annotation" = [
                {
                  "displayName" = "Filesystem % used inodes",
                  "locale"      = "en-us"
                }
              ],
              "class"            = "filesystem",
              "condition"        = "IsAggregate=TRUE",
              "counter"          = "percentusedinodes",
              "counterSpecifier" = "/builtin/filesystem/percentusedinodes",
              "type"             = "builtin",
              "unit"             = "Percent"
            },
            {
              "annotation" = [
                {
                  "displayName" = "CPU IO wait time",
                  "locale"      = "en-us"
                }
              ],
              "class"            = "processor",
              "condition"        = "IsAggregate=TRUE",
              "counter"          = "percentiowaittime",
              "counterSpecifier" = "/builtin/processor/percentiowaittime",
              "type"             = "builtin",
              "unit"             = "Percent"
            },
            {
              "annotation" = [
                {
                  "displayName" = "CPU user time",
                  "locale"      = "en-us"
                }
              ],
              "class"            = "processor",
              "condition"        = "IsAggregate=TRUE",
              "counter"          = "percentusertime",
              "counterSpecifier" = "/builtin/processor/percentusertime",
              "type"             = "builtin",
              "unit"             = "Percent"
            },
            {
              "annotation" = [
                {
                  "displayName" = "CPU nice time",
                  "locale"      = "en-us"
                }
              ],
              "class"            = "processor",
              "condition"        = "IsAggregate=TRUE",
              "counter"          = "percentnicetime",
              "counterSpecifier" = "/builtin/processor/percentnicetime",
              "type"             = "builtin",
              "unit"             = "Percent"
            },
            {
              "annotation" = [
                {
                  "displayName" = "CPU percentage guest OS",
                  "locale"      = "en-us"
                }
              ],
              "class"            = "processor",
              "condition"        = "IsAggregate=TRUE",
              "counter"          = "percentprocessortime",
              "counterSpecifier" = "/builtin/processor/percentprocessortime",
              "type"             = "builtin",
              "unit"             = "Percent"
            },
            {
              "annotation" = [
                {
                  "displayName" = "CPU interrupt time",
                  "locale"      = "en-us"
                }
              ],
              "class"            = "processor",
              "condition"        = "IsAggregate=TRUE",
              "counter"          = "percentinterrupttime",
              "counterSpecifier" = "/builtin/processor/percentinterrupttime",
              "type"             = "builtin",
              "unit"             = "Percent"
            },
            {
              "annotation" = [
                {
                  "displayName" = "CPU idle time",
                  "locale"      = "en-us"
                }
              ],
              "class"            = "processor",
              "condition"        = "IsAggregate=TRUE",
              "counter"          = "percentidletime",
              "counterSpecifier" = "/builtin/processor/percentidletime",
              "type"             = "builtin",
              "unit"             = "Percent"
            },
            {
              "annotation" = [
                {
                  "displayName" = "CPU privileged time",
                  "locale"      = "en-us"
                }
              ],
              "class"            = "processor",
              "condition"        = "IsAggregate=TRUE",
              "counter"          = "percentprivilegedtime",
              "counterSpecifier" = "/builtin/processor/percentprivilegedtime",
              "type"             = "builtin",
              "unit"             = "Percent"
            },
            {
              "annotation" = [
                {
                  "displayName" = "Memory available",
                  "locale"      = "en-us"
                }
              ],
              "class"            = "memory",
              "counter"          = "availablememory",
              "counterSpecifier" = "/builtin/memory/availablememory",
              "type"             = "builtin",
              "unit"             = "Bytes"
            },
            {
              "annotation" = [
                {
                  "displayName" = "Swap percent used",
                  "locale"      = "en-us"
                }
              ],
              "class"            = "memory",
              "counter"          = "percentusedswap",
              "counterSpecifier" = "/builtin/memory/percentusedswap",
              "type"             = "builtin",
              "unit"             = "Percent"
            },
            {
              "annotation" = [
                {
                  "displayName" = "Memory used",
                  "locale"      = "en-us"
                }
              ],
              "class"            = "memory",
              "counter"          = "usedmemory",
              "counterSpecifier" = "/builtin/memory/usedmemory",
              "type"             = "builtin",
              "unit"             = "Bytes"
            },
            {
              "annotation" = [
                {
                  "displayName" = "Page reads",
                  "locale"      = "en-us"
                }
              ],
              "class"            = "memory",
              "counter"          = "pagesreadpersec",
              "counterSpecifier" = "/builtin/memory/pagesreadpersec",
              "type"             = "builtin",
              "unit"             = "CountPerSecond"
            },
            {
              "annotation" = [
                {
                  "displayName" = "Swap available",
                  "locale"      = "en-us"
                }
              ],
              "class"            = "memory",
              "counter"          = "availableswap",
              "counterSpecifier" = "/builtin/memory/availableswap",
              "type"             = "builtin",
              "unit"             = "Bytes"
            },
            {
              "annotation" = [
                {
                  "displayName" = "Swap percent available",
                  "locale"      = "en-us"
                }
              ],
              "class"            = "memory",
              "counter"          = "percentavailableswap",
              "counterSpecifier" = "/builtin/memory/percentavailableswap",
              "type"             = "builtin",
              "unit"             = "Percent"
            },
            {
              "annotation" = [
                {
                  "displayName" = "Mem. percent available",
                  "locale"      = "en-us"
                }
              ],
              "class"            = "memory",
              "counter"          = "percentavailablememory",
              "counterSpecifier" = "/builtin/memory/percentavailablememory",
              "type"             = "builtin",
              "unit"             = "Percent"
            },
            {
              "annotation" = [
                {
                  "displayName" = "Pages",
                  "locale"      = "en-us"
                }
              ],
              "class"            = "memory",
              "counter"          = "pagespersec",
              "counterSpecifier" = "/builtin/memory/pagespersec",
              "type"             = "builtin",
              "unit"             = "CountPerSecond"
            },
            {
              "annotation" = [
                {
                  "displayName" = "Swap used",
                  "locale"      = "en-us"
                }
              ],
              "class"            = "memory",
              "counter"          = "usedswap",
              "counterSpecifier" = "/builtin/memory/usedswap",
              "type"             = "builtin",
              "unit"             = "Bytes"
            },
            {
              "annotation" = [
                {
                  "displayName" = "Memory percentage",
                  "locale"      = "en-us"
                }
              ],
              "class"            = "memory",
              "counter"          = "percentusedmemory",
              "counterSpecifier" = "/builtin/memory/percentusedmemory",
              "type"             = "builtin",
              "unit"             = "Percent"
            },
            {
              "annotation" = [
                {
                  "displayName" = "Page writes",
                  "locale"      = "en-us"
                }
              ],
              "class"            = "memory",
              "counter"          = "pageswrittenpersec",
              "counterSpecifier" = "/builtin/memory/pageswrittenpersec",
              "type"             = "builtin",
              "unit"             = "CountPerSecond"
            }
          ]
        }),
        "syslogEvents" = jsonencode({
          "syslogEventConfiguration" = {
            "LOG_AUTH"     = "LOG_DEBUG",
            "LOG_AUTHPRIV" = "LOG_DEBUG",
            "LOG_CRON"     = "LOG_DEBUG",
            "LOG_DAEMON"   = "LOG_DEBUG",
            "LOG_FTP"      = "LOG_DEBUG",
            "LOG_KERN"     = "LOG_DEBUG",
            "LOG_LOCAL0"   = "LOG_DEBUG",
            "LOG_LOCAL1"   = "LOG_DEBUG",
            "LOG_LOCAL2"   = "LOG_DEBUG",
            "LOG_LOCAL3"   = "LOG_DEBUG",
            "LOG_LOCAL4"   = "LOG_DEBUG",
            "LOG_LOCAL5"   = "LOG_DEBUG",
            "LOG_LOCAL6"   = "LOG_DEBUG",
            "LOG_LOCAL7"   = "LOG_DEBUG",
            "LOG_LPR"      = "LOG_DEBUG",
            "LOG_MAIL"     = "LOG_DEBUG",
            "LOG_NEWS"     = "LOG_DEBUG",
            "LOG_SYSLOG"   = "LOG_DEBUG",
            "LOG_USER"     = "LOG_DEBUG",
            "LOG_UUCP"     = "LOG_DEBUG"
          }
        })
      },
      "sampleRateInSeconds" = 15
    }
  })

  protected_settings = jsonencode({
    "storageAccountName"     = azurerm_storage_account.bootdiag.name,
    "storageAccountSasToken" = data.azurerm_storage_account_sas.bootdiag.sas,
    "storageAccountEndPoint" = "https://core.windows.net",
    "sinksConfig" = {
      "sink" = [
        {
          "name" = "SyslogJsonBlob",
          "type" = "JsonBlob"
        },
        {
          "name" = "LinuxCpuJsonBlob",
          "type" = "JsonBlob"
        }
      ]
    }
  })
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
