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
    name     = "default"
    vm_size  = "Standard_A2m_v2"
    zones    = ["1"]
    max_pods = 110

    os_sku         = "CBLMariner"
    vnet_subnet_id = azurerm_subnet.default.id

    enable_auto_scaling = true
    node_count          = 1
    min_count           = 1
    max_count           = 1

    os_disk_size_gb = 50

    # The Virtual Machine size Standard_A2_v2 does not support EncryptionAtHost.
    enable_host_encryption = false
    # The Virtual Machine size Standard_A2_v2 does not support Ephemeral OS disk."
    #os_disk_type           = "Ephemeral"
    # The virtual machine size Standard_A2_v2 has a max temporary disk size of 21474836480 bytes, but the kubelet disk requires 32212254720 bytes. Use a VM size with larger temporary disk or use the OS disk for kubelet.
    #kubelet_disk_type      = "Temporary"
  }

  identity {
    type = "SystemAssigned"
  }

  local_account_disabled = true
  oidc_issuer_enabled    = true

  key_vault_secrets_provider {
    secret_rotation_enabled  = true
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

  depends_on = [azurerm_resource_provider_registration.ContainerService]
}

resource "azurerm_role_assignment" "jok" {
  scope                = azurerm_kubernetes_cluster.jok.id
  role_definition_name = "Azure Kubernetes Service RBAC Cluster Admin"
  principal_id         = data.azurerm_client_config.this.object_id
}

resource "null_resource" "enable-workload-identity" {
  triggers = {
    id = azurerm_kubernetes_cluster.jok.id
  }

  # https://github.com/hashicorp/terraform-provider-azurerm/issues/18666
  provisioner "local-exec" {
    command = "az aks update -g ${azurerm_kubernetes_cluster.jok.resource_group_name} -n ${azurerm_kubernetes_cluster.jok.name} --enable-workload-identity"
  }
}
