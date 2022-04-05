terraform {
  backend "s3" {
    bucket  = "adorsys-sandbox-terraform-state-files"
    region  = "eu-central-1"
    profile = "adorsys-sandbox"
    key     = "jkr/manual-kubernetes-on-arm/cluster-setup/terraform.state"

    encrypt = true
  }

  required_providers {
    ct = {
      source  = "poseidon/ct"
      version = "~> 0.10"
    }
    aws = {
      version = "~> 4.8"
    }
    random = {
      version = "~> 3.1"
    }
    tls = {
      version = "~> 3.2.0"
    }
  }

  required_version = ">= 1.1"
}
