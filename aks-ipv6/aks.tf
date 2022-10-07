resource "azurerm_resource_provider_registration" "oidc" {
  name = "Microsoft.ContainerService"

  feature {
    name       = "EnableOIDCIssuerPreview"
    registered = true
  }
}

resource "azurerm_kubernetes_cluster" "jok" {
  resource_group_name = data.azurerm_resource_group.default.name
  location            = data.azurerm_resource_group.default.location

  name = "jok"

  automatic_channel_upgrade = "rapid"
  dns_prefix                = "jok"

  auto_scaler_profile {
    expander = "least-waste"
  }

  azure_active_directory_role_based_access_control {
    managed            = true
    azure_rbac_enabled = true
  }

  default_node_pool {
    name                   = "default"
    vm_size                = "Standard_A1_v2"
    node_count             = 1
    min_count              = 1
    max_count              = 1
    enable_auto_scaling    = true
    enable_host_encryption = true
    os_sku                 = "CBLMariner"
    os_disk_size_gb        = 20

    pod_subnet_id = azurerm_subnet.default.id
  }

  identity {
    type = "SystemAssigned"
  }

  local_account_disabled = true
  oidc_issuer_enabled    = true

  maintenance_window {
    allowed {
      day   = "Sunday"
      hours = [23, 0, 1, 2, 3, 4, 5, 6]
    }
    allowed {
      day   = "Monday"
      hours = [23, 0, 1, 2, 3, 4, 5, 6]
    }
    allowed {
      day   = "Tuesday"
      hours = [23, 0, 1, 2, 3, 4, 5, 6]
    }
    allowed {
      day   = "Wednesday"
      hours = [23, 0, 1, 2, 3, 4, 5, 6]
    }
    allowed {
      day   = "Thursday"
      hours = [23, 0, 1, 2, 3, 4, 5, 6]
    }
    allowed {
      day   = "Friday"
      hours = [23, 0, 1, 2, 3, 4, 5, 6]
    }
    allowed {
      day   = "Saturday"
      hours = [23, 0, 1, 2, 3, 4, 5, 6]
    }
  }

  network_profile {
    network_plugin = "azure"
    network_mode   = "transparent"
    network_policy = "calico"

    outbound_type = "loadBalancer"

    ip_versions       = ["IPv4"]
    load_balancer_sku = "basic"
  }

  public_network_access_enabled     = true
  role_based_access_control_enabled = true

  run_command_enabled = true
  sku_tier            = "Free"

  depends_on = [azurerm_resource_provider_registration.oidc]
}

resource "azurerm_kubernetes_cluster_node_pool" "spot" {
  kubernetes_cluster_id  = azurerm_kubernetes_cluster.jok.id
  name                   = "spot"
  vm_size                = "Standard_A2_v2"
  enable_auto_scaling    = true
  enable_host_encryption = true
  os_sku                 = "CBLMariner"
  os_disk_size_gb        = 50

  pod_subnet_id = azurerm_subnet.default.id

  min_count  = 1
  node_count = 1
  max_count  = 3

  upgrade_settings {
    max_surge = "1"
  }

  priority        = "Spot"
  eviction_policy = "Delete"

  mode = "User"
}
