terraform {
  required_version = "~> 0.15"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }

  backend "s3" {
    bucket  = "aws-adorsys-sandbox-statefile"
    region  = "eu-central-1"
    profile = "adorsys-sandbox"
    key     = "jkr/kubernetes-the-hard-way/terraform.state"
  }
}
