provider "aws" {
  profile = "adorsys-sandbox"

  region = "eu-central-1"

  default_tags {
    tags = {
      project = var.name
    }
  }
}

provider "kubernetes" {
  host                   = data.aws_ssm_parameter.cluster_credentials["host"].value
  client_certificate     = data.aws_ssm_parameter.cluster_credentials["client_certificate"].value
  client_key             = data.aws_ssm_parameter.cluster_credentials["client_key"].value
  cluster_ca_certificate = data.aws_ssm_parameter.cluster_credentials["cluster_ca_certificate"].value
}

provider "helm" {
  # https://github.com/hashicorp/terraform-provider-helm/issues/630
  registry_config_path = "repositories.yaml"

  kubernetes {
    host                   = data.aws_ssm_parameter.cluster_credentials["host"].value
    client_certificate     = data.aws_ssm_parameter.cluster_credentials["client_certificate"].value
    client_key             = data.aws_ssm_parameter.cluster_credentials["client_key"].value
    cluster_ca_certificate = data.aws_ssm_parameter.cluster_credentials["cluster_ca_certificate"].value
  }
}