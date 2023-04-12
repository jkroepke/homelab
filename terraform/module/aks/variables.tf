
variable "automatic_channel_upgrade" {
  type        = string
  default     = null
  description = ""
}
variable "azure_policy_enabled" {
  type        = bool
  default     = null
  description = ""
}
variable "disk_encryption_set_id" {
  type        = string
  default     = null
  description = ""
}
variable "dns_prefix" {
  type        = string
  default     = null
  description = ""
}
variable "dns_prefix_private_cluster" {
  type        = string
  default     = null
  description = ""
}
variable "edge_zone" {
  type        = string
  default     = null
  description = ""
}
variable "enable_pod_security_policy" {
  type        = bool
  default     = null
  description = ""
}
variable "http_application_routing_enabled" {
  type        = bool
  default     = null
  description = ""
}
variable "image_cleaner_enabled" {
  type        = bool
  default     = null
  description = ""
}
variable "image_cleaner_interval_hours" {
  type        = number
  default     = null
  description = ""
}
variable "local_account_disabled" {
  type        = bool
  default     = null
  description = ""
}
variable "location" {
  type        = string
  description = ""
}
variable "name" {
  type        = string
  description = ""
}
variable "oidc_issuer_enabled" {
  type        = bool
  default     = null
  description = ""
}
variable "open_service_mesh_enabled" {
  type        = bool
  default     = null
  description = ""
}
variable "private_cluster_enabled" {
  type        = bool
  default     = null
  description = ""
}
variable "private_cluster_public_fqdn_enabled" {
  type        = bool
  default     = null
  description = ""
}
variable "public_network_access_enabled" {
  type        = bool
  default     = null
  description = ""
}
variable "resource_group_name" {
  type        = string
  description = ""
}
variable "role_based_access_control_enabled" {
  type        = bool
  default     = null
  description = ""
}
variable "run_command_enabled" {
  type        = bool
  default     = null
  description = ""
}
variable "sku_tier" {
  type        = string
  default     = "Free"
  description = ""
}
variable "tags" {
  type        = map(string)
  default     = {}
  description = ""
}
variable "workload_identity_enabled" {
  type        = bool
  default     = null
  description = ""
}
variable "aci_connector_linux" {
  type        = object({
          subnet_name = string
})
  description = ""
}
variable "api_server_access_profile" {
  type        = object({
          subnet_id = optional(string)
          vnet_integration_enabled = optional(bool)
})
  description = ""
}
variable "auto_scaler_profile" {
  type        = object({
          balance_similar_node_groups = optional(bool)
          expander = optional(string)
          max_node_provisioning_time = optional(string)
          max_unready_nodes = optional(number)
          max_unready_percentage = optional(number)
          skip_nodes_with_local_storage = optional(bool)
          skip_nodes_with_system_pods = optional(bool)
})
  description = ""
}
variable "azure_active_directory_role_based_access_control" {
  type        = object({
          admin_group_object_ids = optional([list string])
          azure_rbac_enabled = optional(bool)
          client_app_id = optional(string)
          managed = optional(bool)
          server_app_id = optional(string)
          server_app_secret = optional(string)
})
  description = ""
}
variable "confidential_computing" {
  type        = object({
          sgx_quote_helper_enabled = bool
})
  description = ""
}
variable "default_node_pool" {
  type        = object({
          capacity_reservation_group_id = optional(string)
          custom_ca_trust_enabled = optional(bool)
          enable_auto_scaling = optional(bool)
          enable_host_encryption = optional(bool)
          enable_node_public_ip = optional(bool)
          fips_enabled = optional(bool)
          host_group_id = optional(string)
          max_count = optional(number)
          message_of_the_day = optional(string)
          min_count = optional(number)
          name = string
          node_public_ip_prefix_id = optional(string)
          node_taints = optional([list string])
          only_critical_addons_enabled = optional(bool)
          os_disk_type = optional(string)
          pod_subnet_id = optional(string)
          proximity_placement_group_id = optional(string)
          scale_down_mode = optional(string)
          tags = optional([map string])
          type = optional(string)
          ultra_ssd_enabled = optional(bool)
          vm_size = string
          vnet_subnet_id = optional(string)
          zones = optional([set string])
})
  description = ""
}
variable "http_proxy_config" {
  type        = object({
          http_proxy = optional(string)
          https_proxy = optional(string)
          no_proxy = optional([set string])
          trusted_ca = optional(string)
})
  description = ""
}
variable "identity" {
  type        = object({
          identity_ids = optional([set string])
          type = string
})
  description = ""
}
variable "ingress_application_gateway" {
  type        = object({
          gateway_id = optional(string)
          gateway_name = optional(string)
          subnet_cidr = optional(string)
          subnet_id = optional(string)
})
  description = ""
}
variable "key_management_service" {
  type        = object({
          key_vault_key_id = string
          key_vault_network_access = optional(string)
})
  description = ""
}
variable "key_vault_secrets_provider" {
  type        = object({
          secret_rotation_enabled = optional(bool)
          secret_rotation_interval = optional(string)
})
  description = ""
}
variable "kubelet_identity" {
  type        = object({
})
  description = ""
}
variable "linux_profile" {
  type        = object({
          admin_username = string
})
  description = ""
}
variable "maintenance_window" {
  type        = object({
})
  description = ""
}
variable "microsoft_defender" {
  type        = object({
          log_analytics_workspace_id = string
})
  description = ""
}
variable "monitor_metrics" {
  type        = object({
          annotations_allowed = optional(string)
          labels_allowed = optional(string)
})
  description = ""
}
variable "network_profile" {
  type        = object({
          ebpf_data_plane = optional(string)
          load_balancer_sku = optional(string)
          network_plugin = string
          network_plugin_mode = optional(string)
          outbound_type = optional(string)
})
  description = ""
}
variable "oms_agent" {
  type        = object({
          log_analytics_workspace_id = string
})
  description = ""
}
variable "service_principal" {
  type        = object({
          client_id = string
          client_secret = string
})
  description = ""
}
variable "storage_profile" {
  type        = object({
          blob_driver_enabled = optional(bool)
          disk_driver_enabled = optional(bool)
          disk_driver_version = optional(string)
          file_driver_enabled = optional(bool)
          snapshot_controller_enabled = optional(bool)
})
  description = ""
}
variable "timeouts" {
  type        = object({
          create = optional(string)
          delete = optional(string)
          read = optional(string)
          update = optional(string)
})
  description = ""
}
variable "web_app_routing" {
  type        = object({
          dns_zone_id = string
})
  description = ""
}
variable "windows_profile" {
  type        = object({
          admin_password = optional(string)
          admin_username = string
          license = optional(string)
})
  description = ""
}
variable "workload_autoscaler_profile" {
  type        = object({
          keda_enabled = optional(bool)
})
  description = ""
}
