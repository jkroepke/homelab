variable "compartment_ocid" {}
variable "display_name" {}
variable "dns_label" {}
variable "cidr_blocks" {}
variable "is_ipv6enabled" {
  type = bool
}
variable "is_oracle_gua_allocation_enabled" {
  type = bool
}

variable "private_subnets" {
  default = {}
  type = map(object({
    cidr_block = string
    # availability_domain = string
    ipv6_prefix_id = string
  }))
}

variable "public_subnets" {
  default = {}
  type = map(object({
    cidr_block = string
    # availability_domain = string
    ipv6_prefix_id = string
  }))
}
