resource "oci_core_vcn" "this" {
  compartment_id = var.compartment_ocid

  cidr_blocks  = var.cidr_blocks
  display_name = var.display_name
  dns_label    = var.dns_label

  is_ipv6enabled                   = var.is_ipv6enabled
  is_oracle_gua_allocation_enabled = var.is_oracle_gua_allocation_enabled
}

resource "oci_core_subnet" "public" {
  for_each = var.public_subnets

  compartment_id = var.compartment_ocid

  #Required
  vcn_id     = oci_core_vcn.this.id
  cidr_block = each.value.cidr_block

  #Optional
  availability_domain = try(each.value.availability_domain, null)
  display_name        = each.key

  ipv6cidr_blocks            = [cidrsubnet(oci_core_vcn.this.ipv6cidr_blocks[0], 8, each.value.ipv6_prefix_id)]
  prohibit_internet_ingress  = false
  prohibit_public_ip_on_vnic = false
}

resource "oci_core_subnet" "private" {
  for_each = var.private_subnets

  compartment_id = var.compartment_ocid

  vcn_id     = oci_core_vcn.this.id
  cidr_block = each.value.cidr_block

  availability_domain = try(each.value.availability_domain, null)
  display_name        = each.key

  ipv6cidr_blocks            = [cidrsubnet(oci_core_vcn.this.ipv6cidr_blocks[0], 8, each.value.ipv6_prefix_id)]
  prohibit_internet_ingress  = true
  prohibit_public_ip_on_vnic = true
}

resource "oci_core_internet_gateway" "this" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.this.id
  display_name   = var.display_name
}

resource "oci_core_default_route_table" "this" {
  manage_default_resource_id = oci_core_vcn.this.default_route_table_id

  display_name = "default"

  route_rules {
    network_entity_id = oci_core_internet_gateway.this.id
    destination       = "::/0"
    destination_type  = "CIDR_BLOCK"
  }

  route_rules {
    network_entity_id = oci_core_internet_gateway.this.id
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
  }
}
