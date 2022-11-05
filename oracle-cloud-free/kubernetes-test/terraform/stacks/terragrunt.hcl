locals {
  region           = "eu-frankfurt-1"
  s3_namespace     = "frw4trxpz16a"
}

generate "provider" {
  path = "versions.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
terraform {
  required_providers {
    oci = {
      source = "oracle/oci"
      version = "4.98.0"
    }
  }
}

provider "oci" {
  region = "${local.region}"
}
EOF
}

remote_state {
  backend  = "s3"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    bucket                             = "terraform-state"
    key                                = "${path_relative_to_include()}/terraform.tfstate"
    region                             = local.region
    endpoint                           = "https://${local.s3_namespace}.compat.objectstorage.${local.region}.oraclecloud.com"
    encrypt                            = true
    skip_region_validation             = true
    skip_credentials_validation        = true
    skip_metadata_api_check            = true
    skip_bucket_ssencryption           = true
    skip_bucket_enforced_tls           = true
    skip_bucket_public_access_blocking = true
    force_path_style                   = true
  }
}

inputs = {
  region       = "eu-frankfurt-1"
  tenancy_ocid = "ocid1.tenancy.oc1..aaaaaaaa5w3c4yf4dtoulsc4ocscyvsgnxhkwfqnfdw4pvhmbjd3imxcyooq"

  vcn_name       = "default"
  vcn_cidr_block = "10.0.0.0/16"

  kubernetes_version = "1.24.0"
}

