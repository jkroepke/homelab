data "azurerm_kubernetes_service_versions" "current" {
  location        = azurerm_resource_group.jok-default.location
  include_preview = false
}

import {
  id = "/subscriptions/1988b893-553c-4652-bd9b-52f089b21ead/resourceGroups/jok-mpn-default/providers/Microsoft.ContainerService/managedClusters/aks-test-jok"
  to = azurerm_kubernetes_cluster.jok
}

resource "azurerm_kubernetes_cluster" "jok" {
  resource_group_name = azurerm_resource_group.jok-default.name
  location            = azurerm_resource_group.jok-default.location

  name               = "aks-test-jok"
  kubernetes_version = data.azurerm_kubernetes_service_versions.current.latest_version

  private_cluster_enabled   = false
  automatic_upgrade_channel = "rapid"
  dns_prefix                = "jok"

  auto_scaler_profile {
    expander = "least-waste"
  }

  azure_active_directory_role_based_access_control {
    azure_rbac_enabled = true
    tenant_id          = data.azurerm_client_config.this.tenant_id
  }

  default_node_pool {
    name     = "system"
    vm_size  = "Standard_E4ps_v6"
    zones    = ["2"]
    max_pods = 100

    os_sku         = "Ubuntu"
    vnet_subnet_id = azurerm_subnet.jok-default.id
    #pod_subnet_id  = azurerm_subnet.jok-aks-pods.id

    auto_scaling_enabled = true
    node_count          = 1
    min_count           = 1
    max_count           = 1

    os_disk_size_gb = 100

    host_encryption_enabled = true
    # The Virtual Machine size Standard_A2_v2 does not support Ephemeral OS disk."
    #os_disk_type           = "Ephemeral"
    # The virtual machine size Standard_A2_v2 has a max temporary disk size of 21474836480 bytes, but the kubelet disk requires 32212254720 bytes. Use a VM size with larger temporary disk or use the OS disk for kubelet.
    #kubelet_disk_type      = "Temporary"

    only_critical_addons_enabled = false

    upgrade_settings {
      drain_timeout_in_minutes      = 5
      max_surge                     = "1"
      node_soak_duration_in_minutes = 0
    }
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
  node_resource_group       = "rg-${azurerm_resource_group.jok-default.name}-aks"
  oidc_issuer_enabled       = true
  workload_identity_enabled = true

  image_cleaner_enabled        = false
  image_cleaner_interval_hours = 48

  maintenance_window_auto_upgrade {
    utc_offset   = "+00:00"
    frequency   = "Weekly"
    duration    = 6
    interval    = 1
    start_time  = "00:00"
    day_of_week = "Tuesday"
  }

  maintenance_window_node_os {
    utc_offset   = "+00:00"
    frequency  = "Daily"
    duration   = 6
    interval   = 1
    start_time = "00:00"
  }

  network_profile {
    network_plugin      = "azure"
    network_policy      = "azure"
    network_plugin_mode = "overlay"

    outbound_type     = "loadBalancer"
    load_balancer_sku = "standard"

    ip_versions        = ["IPv4"]
    service_cidr       = "100.64.0.0/16"
    dns_service_ip     = "100.64.0.53"
  }

  storage_profile {
    blob_driver_enabled = true
    disk_driver_enabled = true
    file_driver_enabled = true
  }

  role_based_access_control_enabled = true

  run_command_enabled = true
  sku_tier            = "Free"

  depends_on = [
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
  count = 0

  kubernetes_cluster_id = azurerm_kubernetes_cluster.jok.id
  name                  = "win"
  vm_size               = "Standard_A2_v2"
  zones                 = ["1"]
  os_type               = "Windows"
  os_sku                = "Windows2022"
  max_pods              = 250

  vnet_subnet_id = azurerm_subnet.jok-default.id

  auto_scaling_enabled = false
  node_count          = 0

  node_public_ip_enabled = false

  os_disk_size_gb = 100

  # The Virtual Machine size Standard_A2_v2 does not support EncryptionAtHost.
  host_encryption_enabled = false
  # The Virtual Machine size Standard_A2_v2 does not support Ephemeral OS disk."
  #os_disk_type           = "Ephemeral"
  # The virtual machine size Standard_A2_v2 has a max temporary disk size of 21474836480 bytes, but the kubelet disk requires 32212254720 bytes. Use a VM size with larger temporary disk or use the OS disk for kubelet.
  #kubelet_disk_type      = "Temporary"
}
