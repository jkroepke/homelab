terraform {

  backend "s3" {
    bucket  = "adorsys-sandbox-terraform-state-files"
    region  = "eu-central-1"
    profile = "adorsys-sandbox"
    key     = "jkr/kubernetes-controller-asg/terraform.state"

    encrypt = true
  }

  required_providers {
    aws = {}
    ct = {
      source  = "poseidon/ct"
      version = "~> 0.11"
    }
  }

  required_version = ">= 1.1"
}
