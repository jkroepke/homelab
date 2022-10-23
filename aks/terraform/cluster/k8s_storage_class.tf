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
    "csi.storage.k8s.io/provisioner-secret-name"            = kubernetes_secret.csi-jokmspaks-azure-secret.metadata[0].name
    "csi.storage.k8s.io/provisioner-secret-namespace"       = kubernetes_secret.csi-jokmspaks-azure-secret.metadata[0].namespace
    "csi.storage.k8s.io/node-stage-secret-name"             = kubernetes_secret.csi-jokmspaks-azure-secret.metadata[0].name
    "csi.storage.k8s.io/node-stage-secret-namespace"        = kubernetes_secret.csi-jokmspaks-azure-secret.metadata[0].namespace
    "csi.storage.k8s.io/controller-expand-secret-name"      = kubernetes_secret.csi-jokmspaks-azure-secret.metadata[0].name
    "csi.storage.k8s.io/controller-expand-secret-namespace" = kubernetes_secret.csi-jokmspaks-azure-secret.metadata[0].namespace
  }

  mount_options          = ["dir_mode=0777", "file_mode=0777", "uid=0", "gid=0", "mfsymlinks", "cache=strict", "nosharesock", "actimeo=30"]
  reclaim_policy         = "Delete"
  volume_binding_mode    = "Immediate"
  allow_volume_expansion = true
}

resource "kubernetes_secret" "csi-jokmspaks-azure-secret" {
  metadata {
    name = "csi-jokmspaks-azure-secret"
    namespace = "kube-system"
  }

  data = {
    azurestorageaccountname = data.azurerm_storage_account.jokmspaks.name
    azurestorageaccountkey  = data.azurerm_storage_account.jokmspaks.primary_access_key
  }
}
