provider "aws" {
  region  = "eu-central-1"
  profile = "adorsys-sandbox"
}

provider "helm" {
  kubernetes {
    config_path = local.admin_config_location
  }
}
