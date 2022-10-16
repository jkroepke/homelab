data "azurerm_kubernetes_service_versions" "current" {
  location = azurerm_resource_group.default.location
  include_preview = false
}

resource "azurerm_kubernetes_cluster" "jok" {
  resource_group_name = azurerm_resource_group.default.name
  location            = azurerm_resource_group.default.location

  name               = "jok"
  kubernetes_version = data.azurerm_kubernetes_service_versions.current.latest_version

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
    name     = "default"
    vm_size  = "Standard_A2m_v2"
    zones    = ["1"]
    max_pods = 110

    os_sku         = "Ubuntu"
    vnet_subnet_id = azurerm_subnet.default.id

    enable_auto_scaling = true
    node_count          = 1
    min_count           = 1
    max_count           = 1

    os_disk_size_gb = 100

    # The Virtual Machine size Standard_A2_v2 does not support EncryptionAtHost.
    enable_host_encryption = false
    # The Virtual Machine size Standard_A2_v2 does not support Ephemeral OS disk."
    #os_disk_type           = "Ephemeral"
    # The virtual machine size Standard_A2_v2 has a max temporary disk size of 21474836480 bytes, but the kubelet disk requires 32212254720 bytes. Use a VM size with larger temporary disk or use the OS disk for kubelet.
    #kubelet_disk_type      = "Temporary"
  }

  linux_profile {
    admin_username = "adminuser"

    ssh_key {
      key_data = local.public_key
    }
  }

  identity {
    type = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.aks.id]
  }

  kubelet_identity {
    client_id                 = azurerm_user_assigned_identity.aks-kubelet.client_id
    object_id                 = azurerm_user_assigned_identity.aks-kubelet.principal_id
    user_assigned_identity_id = azurerm_user_assigned_identity.aks-kubelet.id
  }

  local_account_disabled    = true
  node_resource_group       = "${azurerm_resource_group.default.name}-aks"
  oidc_issuer_enabled       = true
  workload_identity_enabled = true

  key_vault_secrets_provider {
    secret_rotation_enabled  = false
    secret_rotation_interval = "2m"
  }

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

    outbound_type     = "loadBalancer"
    load_balancer_sku = "standard"

    ip_versions        = ["IPv4"]
    service_cidr       = "100.64.0.0/16"
    docker_bridge_cidr = "172.18.0.1/16"
    dns_service_ip     = "100.64.0.53"
  }

  public_network_access_enabled     = true
  role_based_access_control_enabled = true

  run_command_enabled = true
  sku_tier            = "Free"

  depends_on = [
    azurerm_subscription_policy_assignment.vmss-vm-insights-extension,
    azurerm_subscription_policy_assignment.vmss-vm-insights-dcra,
    azurerm_resource_provider_registration.ContainerService,
    azurerm_role_assignment.mi-aks-contributor,
    azurerm_role_assignment.mi-aks-mi-operator
  ]
}

resource "azurerm_role_assignment" "jok" {
  scope                = azurerm_kubernetes_cluster.jok.id
  role_definition_name = "Azure Kubernetes Service RBAC Cluster Admin"
  principal_id         = data.azurerm_client_config.this.object_id
}
