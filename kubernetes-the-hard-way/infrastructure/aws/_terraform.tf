terraform {
  required_version = "~> 0.13"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }

  backend "s3" {
    bucket  = "aws-adorsys-sandbox-statefile"
    region  = "eu-central-1"
    profile = "adorsys-sandbox"
    key     = "jkr/kubernetes-the-hard-way/terraform.state"
  }
}
