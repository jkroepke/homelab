provider "aws" {
  profile = "adorsys-sandbox"

  region = "eu-central-1"

  endpoints {
    sts = "https://sts.eu-central-1.amazonaws.com"
  }

  default_tags {
    tags = {
      project = var.project
    }
  }
}
