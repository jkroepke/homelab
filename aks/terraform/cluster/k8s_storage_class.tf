data "azurerm_storage_account" "jokmspaks" {
  name                = "jokmspaks"
  resource_group_name = data.azurerm_resource_group.default.name
}

resource "kubernetes_storage_class" "jokmspaks" {
  metadata {
    name = "jokmspaks"
  }

  storage_provisioner = "file.csi.azure.com"

  parameters = {
    resourceGroup  = data.azurerm_storage_account.jokmspaks.resource_group_name
    storageAccount = data.azurerm_storage_account.jokmspaks.name
    shareName      = "aks"
  }

  reclaim_policy = "Delete"
  volume_binding_mode = "Immediate"
}
