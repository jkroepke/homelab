locals {
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCpNmPcScu9AHK6aAVCc5+hxTlv34e1vzyS+1kbbRxOX7XUQ19ko/tSh5xfn2ZySgML6vtRXmJ7vjZ9N6YAgQQ8eSwGDgR9+AJBv0OmPPiPQ9b6XjDS0EC3QOc+PxNIAv/A42TLjJzKq/BSaEPl1B2XA5eyi5TnW+CzijaT9bBrIM3KFGLCAGhGj5uwd0c995VUBjAet4m6bJ2tzvC/BdeMkz+Q2ASU6f0LNm2a6u1q620140Cr3b8vL9UKk9/pUCLYJVBv71ZB5G4KBnhBdL6ZgkQvBDPRDzpWqiUMdZXyuhfWcLrlQdLwvd0+rG9xm6/ZQEHXDR6xbj/X9fn9Yoyv"
  aks_key_vaults = ["aks-credentials"]
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
