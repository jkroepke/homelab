provider "aws" {
  profile = "adorsys-sandbox"

  region = "eu-central-1"

  default_tags {
    tags = {
      project = var.name
    }
  }
}

provider "aws" {
  alias = "us-east-1"

  profile = "adorsys-sandbox"

  region = "us-east-1"

  default_tags {
    tags = {
      project = var.name
    }
  }
}
