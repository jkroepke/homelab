data "azurerm_kubernetes_service_versions" "current" {
  location        = azurerm_resource_group.jok-default.location
  include_preview = false
}

resource "azurerm_kubernetes_cluster" "jok" {
  resource_group_name = azurerm_resource_group.jok-default.name
  location            = azurerm_resource_group.jok-default.location

  name               = "jok"
  kubernetes_version = data.azurerm_kubernetes_service_versions.current.latest_version

  private_cluster_enabled   = false
  automatic_channel_upgrade = "rapid"
  dns_prefix                = "jok"

  api_server_access_profile {
    #authorized_ip_ranges     = ["0.0.0.0/0"]
    vnet_integration_enabled = true
    subnet_id                = azurerm_subnet.jok-aks-api.id
  }

  auto_scaler_profile {
    expander = "least-waste"
  }

  azure_active_directory_role_based_access_control {
    managed            = true
    azure_rbac_enabled = true
  }

  default_node_pool {
    name     = "system"
    vm_size  = "Standard_A2m_v2"
    zones    = ["1"]
    max_pods = 250

    os_sku         = "Ubuntu"
    vnet_subnet_id = azurerm_subnet.jok-default.id
    #pod_subnet_id  = azurerm_subnet.jok-aks-pods.id

    enable_auto_scaling = true
    node_count          = 1
    min_count           = 1
    max_count           = 1

    os_disk_size_gb = 100

    # The Virtual Machine size Standard_A2_v2 does not support EncryptionAtHost.
    # SubscriptionNotEnabledEncryptionAtHost
    #enable_host_encryption = true
    # The Virtual Machine size Standard_A2_v2 does not support Ephemeral OS disk."
    #os_disk_type           = "Ephemeral"
    # The virtual machine size Standard_A2_v2 has a max temporary disk size of 21474836480 bytes, but the kubelet disk requires 32212254720 bytes. Use a VM size with larger temporary disk or use the OS disk for kubelet.
    #kubelet_disk_type      = "Temporary"

    only_critical_addons_enabled = false
  }

  linux_profile {
    admin_username = "adminuser"

    ssh_key {
      key_data = local.public_key
    }
  }

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.aks.id]
  }

  kubelet_identity {
    client_id                 = azurerm_user_assigned_identity.aks-kubelet.client_id
    object_id                 = azurerm_user_assigned_identity.aks-kubelet.principal_id
    user_assigned_identity_id = azurerm_user_assigned_identity.aks-kubelet.id
  }

  key_vault_secrets_provider {
    secret_rotation_enabled = true
  }

  local_account_disabled    = true
  node_resource_group       = "${azurerm_resource_group.jok-default.name}-aks"
  oidc_issuer_enabled       = true
  workload_identity_enabled = true

  image_cleaner_enabled        = true
  image_cleaner_interval_hours = 48

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
    network_plugin      = "azure"
    network_mode        = "transparent"
    #network_policy      = "azure"
    network_plugin_mode = "Overlay"

    outbound_type     = "loadBalancer"
    load_balancer_sku = "standard"

    ip_versions        = ["IPv4"]
    service_cidr       = "100.64.0.0/16"
    docker_bridge_cidr = "172.18.0.1/16"
    dns_service_ip     = "100.64.0.53"
  }

  storage_profile {
    blob_driver_enabled = true
    disk_driver_enabled = true
    file_driver_enabled = true
  }

  public_network_access_enabled     = true
  role_based_access_control_enabled = true

  run_command_enabled = true
  sku_tier            = "Free"

  depends_on = [
    null_resource.ContainerService_Refresh_Register,
    azurerm_role_assignment.mi-aks-contributor,
    azurerm_role_assignment.mi-aks-mi-operator
  ]

  lifecycle {
    ignore_changes = [
      default_node_pool.0.node_count,
      image_cleaner_enabled,
      image_cleaner_interval_hours
    ]
  }
}

resource "azurerm_role_assignment" "jok" {
  scope                = azurerm_kubernetes_cluster.jok.id
  role_definition_name = "Azure Kubernetes Service RBAC Cluster Admin"
  principal_id         = data.azurerm_client_config.this.object_id
}

resource "azurerm_kubernetes_cluster_node_pool" "win" {
  kubernetes_cluster_id = azurerm_kubernetes_cluster.jok.id
  name                  = "win"
  vm_size               = "Standard_A2_v2"
  zones                 = ["1"]
  os_type               = "Windows"
  os_sku                = "Windows2022"
  max_pods              = 250

  vnet_subnet_id = azurerm_subnet.jok-default.id

  enable_auto_scaling = false
  node_count          = 0

  enable_node_public_ip = false

  os_disk_size_gb = 100

  # The Virtual Machine size Standard_A2_v2 does not support EncryptionAtHost.
  enable_host_encryption = false
  # The Virtual Machine size Standard_A2_v2 does not support Ephemeral OS disk."
  #os_disk_type           = "Ephemeral"
  # The virtual machine size Standard_A2_v2 has a max temporary disk size of 21474836480 bytes, but the kubelet disk requires 32212254720 bytes. Use a VM size with larger temporary disk or use the OS disk for kubelet.
  #kubelet_disk_type      = "Temporary"
}
