variable "name" {
  type        = string
  description = "Name of managed identity"
}

variable "resource_group_name" {
  type        = string
  description = "Resource group of managed identity"
}

variable "location" {
  type        = string
  description = "Location of managed identity"
}

variable "oidc_issuer_url" {
  type = string
}

variable "subject" {
  type = string
}
