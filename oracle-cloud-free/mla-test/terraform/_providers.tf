terraform {
  required_providers {
    oci = {
      source = "oracle/oci"
      version = "~> 4.98"
    }
  }
}

provider "oci" {
  region = var.region
}
