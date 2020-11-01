terraform {
  required_version = "~> 0.13"

  backend "s3" {
    bucket  = "adorsys-sandbox-terraform-state-files"
    region  = "eu-central-1"
    profile = "adorsys-sandbox"
    key     = "jkr/kubernetes-the-hard-way-challenge/terraform.state"

    encrypt = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }

    helm = {
      source  = "hashicorp/helm"
      version = "~> 1.3.2"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 1.13.3"
    }

    keycloak = {
      source = "mrparkers/keycloak"
      version = "~> 2.0.0"
    }

    template = {
      source = "hashicorp/template"
      version = "~> 2.2"
    }

    tls = {
      source  = "hashicorp/tls"
      version = "~> 3.0"
    }
  }
}
