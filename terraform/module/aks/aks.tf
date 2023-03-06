resource "azurerm_kubernetes_cluster" "this" {
  count = var.existing_aks_cluster ? 0 : 1


  automatic_channel_upgrade           = var.automatic_channel_upgrade
  azure_policy_enabled                = var.azure_policy_enabled
  disk_encryption_set_id              = var.disk_encryption_set_id
  dns_prefix                          = var.dns_prefix
  dns_prefix_private_cluster          = var.dns_prefix_private_cluster
  edge_zone                           = var.edge_zone
  enable_pod_security_policy          = var.enable_pod_security_policy
  http_application_routing_enabled    = var.http_application_routing_enabled
  image_cleaner_enabled               = var.image_cleaner_enabled
  image_cleaner_interval_hours        = var.image_cleaner_interval_hours
  local_account_disabled              = var.local_account_disabled
  location                            = var.location
  name                                = var.name
  oidc_issuer_enabled                 = var.oidc_issuer_enabled
  open_service_mesh_enabled           = var.open_service_mesh_enabled
  private_cluster_enabled             = var.private_cluster_enabled
  private_cluster_public_fqdn_enabled = var.private_cluster_public_fqdn_enabled
  public_network_access_enabled       = var.public_network_access_enabled
  resource_group_name                 = var.resource_group_name
  role_based_access_control_enabled   = var.role_based_access_control_enabled
  run_command_enabled                 = var.run_command_enabled
  sku_tier                            = var.sku_tier
  tags                                = var.tags
  workload_identity_enabled           = var.workload_identity_enabled

  dynamic "aci_connector_linux" {
    for_each = var.aci_connector_linux != null ? [1] : []

    content {
      subnet_name = var.aci_connector_linux.subnet_name
    }
  }

  dynamic "api_server_access_profile" {
    for_each = var.api_server_access_profile != null ? [1] : []

    content {
      subnet_id                = try(var.api_server_access_profile.subnet_id, null)
      vnet_integration_enabled = try(var.api_server_access_profile.vnet_integration_enabled, null)
    }
  }

  dynamic "auto_scaler_profile" {
    for_each = var.auto_scaler_profile != null ? [1] : []

    content {
      balance_similar_node_groups   = try(var.auto_scaler_profile.balance_similar_node_groups, null)
      expander                      = try(var.auto_scaler_profile.expander, null)
      max_node_provisioning_time    = try(var.auto_scaler_profile.max_node_provisioning_time, null)
      max_unready_nodes             = try(var.auto_scaler_profile.max_unready_nodes, null)
      max_unready_percentage        = try(var.auto_scaler_profile.max_unready_percentage, null)
      skip_nodes_with_local_storage = try(var.auto_scaler_profile.skip_nodes_with_local_storage, null)
      skip_nodes_with_system_pods   = try(var.auto_scaler_profile.skip_nodes_with_system_pods, null)
    }
  }

  dynamic "azure_active_directory_role_based_access_control" {
    for_each = var.azure_active_directory_role_based_access_control != null ? [1] : []

    content {
      admin_group_object_ids = try(var.azure_active_directory_role_based_access_control.admin_group_object_ids, null)
      azure_rbac_enabled     = try(var.azure_active_directory_role_based_access_control.azure_rbac_enabled, null)
      client_app_id          = try(var.azure_active_directory_role_based_access_control.client_app_id, null)
      managed                = try(var.azure_active_directory_role_based_access_control.managed, null)
      server_app_id          = try(var.azure_active_directory_role_based_access_control.server_app_id, null)
      server_app_secret      = try(var.azure_active_directory_role_based_access_control.server_app_secret, null)
    }
  }

  dynamic "confidential_computing" {
    for_each = var.confidential_computing != null ? [1] : []

    content {
      sgx_quote_helper_enabled = var.confidential_computing.sgx_quote_helper_enabled
    }
  }

  dynamic "default_node_pool" {
    for_each = var.default_node_pool != null ? [1] : []

    content {
      capacity_reservation_group_id = try(var.default_node_pool.capacity_reservation_group_id, null)
      custom_ca_trust_enabled       = try(var.default_node_pool.custom_ca_trust_enabled, null)
      enable_auto_scaling           = try(var.default_node_pool.enable_auto_scaling, null)
      enable_host_encryption        = try(var.default_node_pool.enable_host_encryption, null)
      enable_node_public_ip         = try(var.default_node_pool.enable_node_public_ip, null)
      fips_enabled                  = try(var.default_node_pool.fips_enabled, null)
      host_group_id                 = try(var.default_node_pool.host_group_id, null)
      max_count                     = try(var.default_node_pool.max_count, null)
      message_of_the_day            = try(var.default_node_pool.message_of_the_day, null)
      min_count                     = try(var.default_node_pool.min_count, null)
      name                          = var.default_node_pool.name
      node_public_ip_prefix_id      = try(var.default_node_pool.node_public_ip_prefix_id, null)
      node_taints                   = try(var.default_node_pool.node_taints, null)
      only_critical_addons_enabled  = try(var.default_node_pool.only_critical_addons_enabled, null)
      os_disk_type                  = try(var.default_node_pool.os_disk_type, null)
      pod_subnet_id                 = try(var.default_node_pool.pod_subnet_id, null)
      proximity_placement_group_id  = try(var.default_node_pool.proximity_placement_group_id, null)
      scale_down_mode               = try(var.default_node_pool.scale_down_mode, null)
      tags                          = try(var.default_node_pool.tags, null)
      type                          = try(var.default_node_pool.type, null)
      ultra_ssd_enabled             = try(var.default_node_pool.ultra_ssd_enabled, null)
      vm_size                       = var.default_node_pool.vm_size
      vnet_subnet_id                = try(var.default_node_pool.vnet_subnet_id, null)
      zones                         = try(var.default_node_pool.zones, null)

      dynamic "kubelet_config" {
        for_each = var.default_node_pool.kubelet_config != null ? [1] : []

        content {
          allowed_unsafe_sysctls    = try(var.default_node_pool.kubelet_config.allowed_unsafe_sysctls, null)
          container_log_max_line    = try(var.default_node_pool.kubelet_config.container_log_max_line, null)
          container_log_max_size_mb = try(var.default_node_pool.kubelet_config.container_log_max_size_mb, null)
          cpu_cfs_quota_enabled     = try(var.default_node_pool.kubelet_config.cpu_cfs_quota_enabled, null)
          cpu_cfs_quota_period      = try(var.default_node_pool.kubelet_config.cpu_cfs_quota_period, null)
          cpu_manager_policy        = try(var.default_node_pool.kubelet_config.cpu_manager_policy, null)
          image_gc_high_threshold   = try(var.default_node_pool.kubelet_config.image_gc_high_threshold, null)
          image_gc_low_threshold    = try(var.default_node_pool.kubelet_config.image_gc_low_threshold, null)
          pod_max_pid               = try(var.default_node_pool.kubelet_config.pod_max_pid, null)
          topology_manager_policy   = try(var.default_node_pool.kubelet_config.topology_manager_policy, null)
        }
      }

      dynamic "linux_os_config" {
        for_each = var.default_node_pool.linux_os_config != null ? [1] : []

        content {
          swap_file_size_mb             = try(var.default_node_pool.linux_os_config.swap_file_size_mb, null)
          transparent_huge_page_defrag  = try(var.default_node_pool.linux_os_config.transparent_huge_page_defrag, null)
          transparent_huge_page_enabled = try(var.default_node_pool.linux_os_config.transparent_huge_page_enabled, null)

          dynamic "sysctl_config" {
            for_each = var.default_node_pool.linux_os_config.sysctl_config != null ? [1] : []

            content {
              fs_aio_max_nr                      = try(var.default_node_pool.linux_os_config.sysctl_config.fs_aio_max_nr, null)
              fs_file_max                        = try(var.default_node_pool.linux_os_config.sysctl_config.fs_file_max, null)
              fs_inotify_max_user_watches        = try(var.default_node_pool.linux_os_config.sysctl_config.fs_inotify_max_user_watches, null)
              fs_nr_open                         = try(var.default_node_pool.linux_os_config.sysctl_config.fs_nr_open, null)
              kernel_threads_max                 = try(var.default_node_pool.linux_os_config.sysctl_config.kernel_threads_max, null)
              net_core_netdev_max_backlog        = try(var.default_node_pool.linux_os_config.sysctl_config.net_core_netdev_max_backlog, null)
              net_core_optmem_max                = try(var.default_node_pool.linux_os_config.sysctl_config.net_core_optmem_max, null)
              net_core_rmem_default              = try(var.default_node_pool.linux_os_config.sysctl_config.net_core_rmem_default, null)
              net_core_rmem_max                  = try(var.default_node_pool.linux_os_config.sysctl_config.net_core_rmem_max, null)
              net_core_somaxconn                 = try(var.default_node_pool.linux_os_config.sysctl_config.net_core_somaxconn, null)
              net_core_wmem_default              = try(var.default_node_pool.linux_os_config.sysctl_config.net_core_wmem_default, null)
              net_core_wmem_max                  = try(var.default_node_pool.linux_os_config.sysctl_config.net_core_wmem_max, null)
              net_ipv4_ip_local_port_range_max   = try(var.default_node_pool.linux_os_config.sysctl_config.net_ipv4_ip_local_port_range_max, null)
              net_ipv4_ip_local_port_range_min   = try(var.default_node_pool.linux_os_config.sysctl_config.net_ipv4_ip_local_port_range_min, null)
              net_ipv4_neigh_default_gc_thresh1  = try(var.default_node_pool.linux_os_config.sysctl_config.net_ipv4_neigh_default_gc_thresh1, null)
              net_ipv4_neigh_default_gc_thresh2  = try(var.default_node_pool.linux_os_config.sysctl_config.net_ipv4_neigh_default_gc_thresh2, null)
              net_ipv4_neigh_default_gc_thresh3  = try(var.default_node_pool.linux_os_config.sysctl_config.net_ipv4_neigh_default_gc_thresh3, null)
              net_ipv4_tcp_fin_timeout           = try(var.default_node_pool.linux_os_config.sysctl_config.net_ipv4_tcp_fin_timeout, null)
              net_ipv4_tcp_keepalive_intvl       = try(var.default_node_pool.linux_os_config.sysctl_config.net_ipv4_tcp_keepalive_intvl, null)
              net_ipv4_tcp_keepalive_probes      = try(var.default_node_pool.linux_os_config.sysctl_config.net_ipv4_tcp_keepalive_probes, null)
              net_ipv4_tcp_keepalive_time        = try(var.default_node_pool.linux_os_config.sysctl_config.net_ipv4_tcp_keepalive_time, null)
              net_ipv4_tcp_max_syn_backlog       = try(var.default_node_pool.linux_os_config.sysctl_config.net_ipv4_tcp_max_syn_backlog, null)
              net_ipv4_tcp_max_tw_buckets        = try(var.default_node_pool.linux_os_config.sysctl_config.net_ipv4_tcp_max_tw_buckets, null)
              net_ipv4_tcp_tw_reuse              = try(var.default_node_pool.linux_os_config.sysctl_config.net_ipv4_tcp_tw_reuse, null)
              net_netfilter_nf_conntrack_buckets = try(var.default_node_pool.linux_os_config.sysctl_config.net_netfilter_nf_conntrack_buckets, null)
              net_netfilter_nf_conntrack_max     = try(var.default_node_pool.linux_os_config.sysctl_config.net_netfilter_nf_conntrack_max, null)
              vm_max_map_count                   = try(var.default_node_pool.linux_os_config.sysctl_config.vm_max_map_count, null)
              vm_swappiness                      = try(var.default_node_pool.linux_os_config.sysctl_config.vm_swappiness, null)
              vm_vfs_cache_pressure              = try(var.default_node_pool.linux_os_config.sysctl_config.vm_vfs_cache_pressure, null)
            }
          }
        }
      }

      dynamic "node_network_profile" {
        for_each = var.default_node_pool.node_network_profile != null ? [1] : []

        content {
          node_public_ip_tags = try(var.default_node_pool.node_network_profile.node_public_ip_tags, null)
        }
      }

      dynamic "upgrade_settings" {
        for_each = var.default_node_pool.upgrade_settings != null ? [1] : []

        content {
          max_surge = var.default_node_pool.upgrade_settings.max_surge
        }
      }
    }
  }

  dynamic "http_proxy_config" {
    for_each = var.http_proxy_config != null ? [1] : []

    content {
      http_proxy  = try(var.http_proxy_config.http_proxy, null)
      https_proxy = try(var.http_proxy_config.https_proxy, null)
      no_proxy    = try(var.http_proxy_config.no_proxy, null)
      trusted_ca  = try(var.http_proxy_config.trusted_ca, null)
    }
  }

  dynamic "identity" {
    for_each = var.identity != null ? [1] : []

    content {
      identity_ids = try(var.identity.identity_ids, null)
      type         = var.identity.type
    }
  }

  dynamic "ingress_application_gateway" {
    for_each = var.ingress_application_gateway != null ? [1] : []

    content {
      gateway_id   = try(var.ingress_application_gateway.gateway_id, null)
      gateway_name = try(var.ingress_application_gateway.gateway_name, null)
      subnet_cidr  = try(var.ingress_application_gateway.subnet_cidr, null)
      subnet_id    = try(var.ingress_application_gateway.subnet_id, null)
    }
  }

  dynamic "key_management_service" {
    for_each = var.key_management_service != null ? [1] : []

    content {
      key_vault_key_id         = var.key_management_service.key_vault_key_id
      key_vault_network_access = try(var.key_management_service.key_vault_network_access, null)
    }
  }

  dynamic "key_vault_secrets_provider" {
    for_each = var.key_vault_secrets_provider != null ? [1] : []

    content {
      secret_rotation_enabled  = try(var.key_vault_secrets_provider.secret_rotation_enabled, null)
      secret_rotation_interval = try(var.key_vault_secrets_provider.secret_rotation_interval, null)
    }
  }

  dynamic "kubelet_identity" {
    for_each = var.kubelet_identity != null ? [1] : []

    content {
    }
  }

  dynamic "linux_profile" {
    for_each = var.linux_profile != null ? [1] : []

    content {
      admin_username = var.linux_profile.admin_username

      dynamic "ssh_key" {
        for_each = var.linux_profile.ssh_key != null ? [1] : []

        content {
          key_data = var.linux_profile.ssh_key.key_data
        }
      }
    }
  }

  dynamic "maintenance_window" {
    for_each = var.maintenance_window != null ? [1] : []

    content {

      dynamic "allowed" {
        for_each = var.maintenance_window.allowed != null ? [1] : []

        content {
          day   = var.maintenance_window.allowed.day
          hours = var.maintenance_window.allowed.hours
        }
      }

      dynamic "not_allowed" {
        for_each = var.maintenance_window.not_allowed != null ? [1] : []

        content {
          end   = var.maintenance_window.not_allowed.end
          start = var.maintenance_window.not_allowed.start
        }
      }
    }
  }

  dynamic "microsoft_defender" {
    for_each = var.microsoft_defender != null ? [1] : []

    content {
      log_analytics_workspace_id = var.microsoft_defender.log_analytics_workspace_id
    }
  }

  dynamic "monitor_metrics" {
    for_each = var.monitor_metrics != null ? [1] : []

    content {
      annotations_allowed = try(var.monitor_metrics.annotations_allowed, null)
      labels_allowed      = try(var.monitor_metrics.labels_allowed, null)
    }
  }

  dynamic "network_profile" {
    for_each = var.network_profile != null ? [1] : []

    content {
      ebpf_data_plane     = try(var.network_profile.ebpf_data_plane, null)
      load_balancer_sku   = try(var.network_profile.load_balancer_sku, null)
      network_plugin      = var.network_profile.network_plugin
      network_plugin_mode = try(var.network_profile.network_plugin_mode, null)
      outbound_type       = try(var.network_profile.outbound_type, null)

      dynamic "load_balancer_profile" {
        for_each = var.network_profile.load_balancer_profile != null ? [1] : []

        content {
          idle_timeout_in_minutes  = try(var.network_profile.load_balancer_profile.idle_timeout_in_minutes, null)
          outbound_ports_allocated = try(var.network_profile.load_balancer_profile.outbound_ports_allocated, null)
        }
      }

      dynamic "nat_gateway_profile" {
        for_each = var.network_profile.nat_gateway_profile != null ? [1] : []

        content {
          idle_timeout_in_minutes = try(var.network_profile.nat_gateway_profile.idle_timeout_in_minutes, null)
        }
      }
    }
  }

  dynamic "oms_agent" {
    for_each = var.oms_agent != null ? [1] : []

    content {
      log_analytics_workspace_id = var.oms_agent.log_analytics_workspace_id
    }
  }

  dynamic "service_principal" {
    for_each = var.service_principal != null ? [1] : []

    content {
      client_id     = var.service_principal.client_id
      client_secret = var.service_principal.client_secret
    }
  }

  dynamic "storage_profile" {
    for_each = var.storage_profile != null ? [1] : []

    content {
      blob_driver_enabled         = try(var.storage_profile.blob_driver_enabled, null)
      disk_driver_enabled         = try(var.storage_profile.disk_driver_enabled, null)
      disk_driver_version         = try(var.storage_profile.disk_driver_version, null)
      file_driver_enabled         = try(var.storage_profile.file_driver_enabled, null)
      snapshot_controller_enabled = try(var.storage_profile.snapshot_controller_enabled, null)
    }
  }

  dynamic "timeouts" {
    for_each = var.timeouts != null ? [1] : []

    content {
      create = try(var.timeouts.create, null)
      delete = try(var.timeouts.delete, null)
      read   = try(var.timeouts.read, null)
      update = try(var.timeouts.update, null)
    }
  }

  dynamic "web_app_routing" {
    for_each = var.web_app_routing != null ? [1] : []

    content {
      dns_zone_id = var.web_app_routing.dns_zone_id
    }
  }

  dynamic "windows_profile" {
    for_each = var.windows_profile != null ? [1] : []

    content {
      admin_password = try(var.windows_profile.admin_password, null)
      admin_username = var.windows_profile.admin_username
      license        = try(var.windows_profile.license, null)

      dynamic "gmsa" {
        for_each = var.windows_profile.gmsa != null ? [1] : []

        content {
          dns_server  = var.windows_profile.gmsa.dns_server
          root_domain = var.windows_profile.gmsa.root_domain
        }
      }
    }
  }

  dynamic "workload_autoscaler_profile" {
    for_each = var.workload_autoscaler_profile != null ? [1] : []

    content {
      keda_enabled = try(var.workload_autoscaler_profile.keda_enabled, null)
    }
  }
}
