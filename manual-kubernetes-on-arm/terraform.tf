terraform {

  backend "s3" {
    bucket  = "adorsys-sandbox-terraform-state-files"
    region  = "eu-central-1"
    profile = "adorsys-sandbox"
    key     = "jkr/manual-kubernetes-on-arm/terraform.state"

    encrypt = true
  }

  required_providers {
    aws = {}
  }

  required_version = ">= 1.1"
}
