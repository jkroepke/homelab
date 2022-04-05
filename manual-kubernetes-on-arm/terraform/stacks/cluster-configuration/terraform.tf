terraform {
  backend "s3" {
    bucket  = "adorsys-sandbox-terraform-state-files"
    region  = "eu-central-1"
    profile = "adorsys-sandbox"
    key     = "jkr/manual-kubernetes-on-arm/cluster/terraform.state"

    encrypt = true
  }

  required_providers {
    aws = {
      version = "~> 4.8"
    }
  }

  required_version = ">= 1.1"
}
