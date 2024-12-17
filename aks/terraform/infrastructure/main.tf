locals {
  public_key     = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCpNmPcScu9AHK6aAVCc5+hxTlv34e1vzyS+1kbbRxOX7XUQ19ko/tSh5xfn2ZySgML6vtRXmJ7vjZ9N6YAgQQ8eSwGDgR9+AJBv0OmPPiPQ9b6XjDS0EC3QOc+PxNIAv/A42TLjJzKq/BSaEPl1B2XA5eyi5TnW+CzijaT9bBrIM3KFGLCAGhGj5uwd0c995VUBjAet4m6bJ2tzvC/BdeMkz+Q2ASU6f0LNm2a6u1q620140Cr3b8vL9UKk9/pUCLYJVBv71ZB5G4KBnhBdL6ZgkQvBDPRDzpWqiUMdZXyuhfWcLrlQdLwvd0+rG9xm6/ZQEHXDR6xbj/X9fn9Yoyv"
  aks_key_vaults = ["kv-jok-aks-credentials"]
}

data "azurerm_client_config" "this" {}
data "azurerm_subscription" "current" {}

import {
  id = "/subscriptions/${data.azurerm_client_config.this.subscription_id}/providers/Microsoft.Compute"
  to = azurerm_resource_provider_registration.encryption_at_host
}

resource "azurerm_resource_provider_registration" "encryption_at_host" {
  name = "Microsoft.Compute"

  feature {
    name       = "EncryptionAtHost"
    registered = true
  }

  lifecycle {
    ignore_changes = [
      feature,
    ]
  }
}

resource "null_resource" "ContainerService_Feature_Preview" {
  for_each = toset([
    "EnableWorkloadIdentityPreview",
    "EnablePodIdentityPreview",
    "KubeletDisk",
    "AKS-EnableDualStack",
    "EnableImageCleanerPreview",
    "AKS-PrometheusAddonPreview",
    "CustomNodeConfigPreview",
    "EnableEphemeralOSDiskPreview",
    "MaxSurgePreview",
    "WindowsNetworkPolicyPreview",
    "EnableAPIServerVnetIntegrationPreview",
    "CiliumDataplanePreview",
    "AzureOverlayPreview",
    "PodSubnetPreview",
  ])

  triggers = {
    feature = each.key
  }

  provisioner "local-exec" {
    command = "az feature register --namespace Microsoft.ContainerService --name ${self.triggers.feature} --subscription ${data.azurerm_subscription.current.subscription_id}"
  }
}

resource "null_resource" "ContainerService_Refresh_Register" {
  triggers = {
    features = join(",", [for i in null_resource.ContainerService_Feature_Preview : i.triggers.feature])
  }

  provisioner "local-exec" {
    command = "az provider register --namespace Microsoft.ContainerService --subscription ${data.azurerm_subscription.current.subscription_id}"
  }
}


resource "azurerm_resource_provider_registration" "ContainerService" {
  count = 0

  name = "Microsoft.ContainerService"

  dynamic "feature" {
    for_each = toset([
      "EnableWorkloadIdentityPreview",
      "EnablePodIdentityPreview",
      "KubeletDisk",
      "AKS-EnableDualStack",
      "EnableImageCleanerPreview",
      "AKS-PrometheusAddonPreview",
      "CustomNodeConfigPreview",
      "EnableEphemeralOSDiskPreview",
      "MaxSurgePreview",
      "WindowsNetworkPolicyPreview",
      "EnableAPIServerVnetIntegrationPreview",
      "CiliumDataplanePreview",
      "AzureOverlayPreview",
      "PodSubnetPreview",
    ])

    content {
      name       = feature.key
      registered = true
    }
  }
}
