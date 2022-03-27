provider "aws" {
  profile = "adorsys-sandbox"

  region = "eu-central-1"

  default_tags {
    tags = {
      project = local.project
    }
  }
}
