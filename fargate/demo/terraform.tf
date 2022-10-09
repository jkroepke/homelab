terraform {
  backend "s3" {
    bucket = "tf-mod-lib-tfstate"
    key    = "jok/cks-cluster.tfstate"
    region = "eu-central-1"

    encrypt = true
  }

  required_providers {
    aws = {}
  }

  required_version = ">= 1.1"
}

provider "aws" {
  region = "eu-central-1"

  default_tags {
    tags = {
      cdt-owner = "jok"
      project   = var.project
    }
  }
}
