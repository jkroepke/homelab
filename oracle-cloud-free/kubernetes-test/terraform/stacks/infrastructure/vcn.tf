locals {
  public_subnets = {
    "public" = {
      cidr_block     = cidrsubnet(var.vcn_cidr_block, 1, 0)
      ipv6_prefix_id = 0
    }
  }
  private_subnets = {
    "private" = {
      cidr_block     = cidrsubnet(var.vcn_cidr_block, 1, 1)
      ipv6_prefix_id = 1
    }
  }
}

module "vpc" {
  source = "../../../../modules/oci/vcn"

  compartment_ocid = var.tenancy_ocid

  cidr_blocks                      = [var.vcn_cidr_block]
  display_name                     = "kubernetes"
  dns_label                        = "k8s"
  is_ipv6enabled                   = true
  is_oracle_gua_allocation_enabled = true

  public_subnets  = local.public_subnets
  private_subnets = local.private_subnets
}
