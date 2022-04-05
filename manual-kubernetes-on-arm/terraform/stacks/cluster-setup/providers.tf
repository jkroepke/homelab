provider "aws" {
  profile = "adorsys-sandbox"
  region  = "eu-central-1"

  endpoints {
    sts = "https://sts.eu-central-1.amazonaws.com"
  }

  default_tags {
    tags = {
      project = var.project_name
    }
  }
}

provider "aws" {
  alias = "us-east-1"

  profile = "adorsys-sandbox"
  region  = "us-east-1"

  default_tags {
    tags = {
      project = var.project_name
    }
  }
}
