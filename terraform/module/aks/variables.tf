
variable "automatic_channel_upgrade" {
  type        = string
  description = ""
}
variable "azure_policy_enabled" {
  type        = bool
  description = ""
}
variable "disk_encryption_set_id" {
  type        = string
  description = ""
}
variable "dns_prefix" {
  type        = string
  description = ""
}
variable "dns_prefix_private_cluster" {
  type        = string
  description = ""
}
variable "edge_zone" {
  type        = string
  description = ""
}
variable "enable_pod_security_policy" {
  type        = bool
  description = ""
}
variable "http_application_routing_enabled" {
  type        = bool
  description = ""
}
variable "image_cleaner_enabled" {
  type        = bool
  description = ""
}
variable "image_cleaner_interval_hours" {
  type        = number
  description = ""
}
variable "local_account_disabled" {
  type        = bool
  description = ""
}
variable "location" {
  type        = string
  default     = { "sku_tier" : "Free" }
  description = ""
}
variable "name" {
  type        = string
  default     = { "sku_tier" : "Free" }
  description = ""
}
variable "oidc_issuer_enabled" {
  type        = bool
  description = ""
}
variable "open_service_mesh_enabled" {
  type        = bool
  description = ""
}
variable "private_cluster_enabled" {
  type        = bool
  description = ""
}
variable "private_cluster_public_fqdn_enabled" {
  type        = bool
  description = ""
}
variable "public_network_access_enabled" {
  type        = bool
  description = ""
}
variable "resource_group_name" {
  type        = string
  default     = { "sku_tier" : "Free" }
  description = ""
}
variable "role_based_access_control_enabled" {
  type        = bool
  description = ""
}
variable "run_command_enabled" {
  type        = bool
  description = ""
}
variable "sku_tier" {
  type        = string
  description = ""
}
variable "tags" {
  type        = map(string)
  default     = {}
  description = ""
}
variable "workload_identity_enabled" {
  type        = bool
  description = ""
}
