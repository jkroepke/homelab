variable "name" {}
variable "location" {}
variable "resource_group_name" {}
variable "subnet_id" {}
variable "public_key" {}
variable "dns_zone_name" {}
variable "dns_resource_group_name" {}
variable "boot_diagnostics_storage_account_uri" {}
variable "type" {
  type = string
  default = "linux"
}
