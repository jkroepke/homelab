locals {
  aks_key_vaults = ["kubernetes-dex"]
}

data "azurerm_client_config" "this" {}

resource "azurerm_resource_provider_registration" "ContainerService" {
  name = "Microsoft.ContainerService"

  feature {
    name       = "EnableWorkloadIdentityPreview"
    registered = true
  }

  feature {
    name       = "EnablePodIdentityPreview"
    registered = true
  }

  feature {
    name       = "EnableOIDCIssuerPreview"
    registered = true
  }

  feature {
    name       = "KubeletDisk"
    registered = true
  }

  feature {
    name       = "AKS-EnableDualStack"
    registered = true
  }
}
