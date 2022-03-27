provider "aws" {
  profile = "adorsys-sandbox"

  region = "eu-central-1"

  default_tags {
    tags = {
      project = local.project
    }
  }
}

provider "kubernetes" {
  host = module.kubernetes-control-plane.kubernetes_api_server

  client_certificate     = module.kubernetes-control-plane.kubernetes_client_certificate
  client_key             = module.kubernetes-control-plane.kubernetes_client_key
  cluster_ca_certificate = module.kubernetes-control-plane.kubernetes_cluster_ca_certificate
}

provider "helm" {
  # https://github.com/hashicorp/terraform-provider-helm/issues/630
  registry_config_path = "repositories.yaml"

  kubernetes {
    client_certificate     = module.kubernetes-control-plane.kubernetes_client_certificate
    client_key             = module.kubernetes-control-plane.kubernetes_client_key
    cluster_ca_certificate = module.kubernetes-control-plane.kubernetes_cluster_ca_certificate
  }
}
