variable "name" {}
variable "location" {}
variable "resource_group_name" {}
variable "subnet_id" {}
variable "public_key" {}
variable "dns_zone_name" {}
variable "dns_resource_group_name" {}
variable "boot_diagnostics_storage_account_uri" {}
variable "enable_public_interface" {
  type    = bool
  default = false
}

variable "type" {
  type    = string
  default = "linux"
}

variable "size" {
  type    = string
  default = "Standard_B1ms"
}

variable "disk_encryption_set_id" {
  type    = string
}
