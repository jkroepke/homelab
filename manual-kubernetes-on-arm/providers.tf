provider "aws" {
  profile = "adorsys-sandbox"

  region = "eu-central-1"

  default_tags {
    tags = {
      project = "jkr-manual-kubernetes-on-arm"
    }
  }
}
