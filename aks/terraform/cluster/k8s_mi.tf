locals {
  managed-identities = {
    external-dns = {
      namespace = "infra-external-dns"
      client-id = data.azurerm_user_assigned_identity.external-dns.client_id
    }
    crossplane = {
      namespace = "infra-crossplane"
      client-id = data.azurerm_user_assigned_identity.external-dns.client_id
    }
    cortex = {
      namespace = "infra-cortex"
      client-id = data.azurerm_user_assigned_identity.aks-storage-account.client_id
    }
    loki = {
      namespace = "infra-loki"
      client-id = data.azurerm_user_assigned_identity.aks-storage-account.client_id
    }
    grafana = {
      namespace = "infra-prometheus"
      client-id = data.azurerm_user_assigned_identity.aks-monitoring-reader.client_id
    }
  }
}

resource "kubernetes_namespace" "managed-identities" {
  for_each = local.managed-identities

  metadata {
    name = each.value.namespace
  }
}

resource "kubernetes_service_account" "managed-identities" {
  for_each = local.managed-identities

  metadata {
    name      = each.key
    namespace = kubernetes_namespace.managed-identities[each.key].metadata[0].name
    annotations = {
      "azure.workload.identity/client-id" = each.value.client-id
    }
    labels = {
      "azure.workload.identity/use" = "true"
    }
  }
}


data "azurerm_user_assigned_identity" "keyvault-access" {
  name                = "keyvault-access"
  resource_group_name = data.azurerm_resource_group.default.name
}

data "azurerm_user_assigned_identity" "external-dns" {
  name                = "external-dns"
  resource_group_name = data.azurerm_resource_group.default.name
}

data "azurerm_user_assigned_identity" "aks-storage-account" {
  name                = "aks-storage-account"
  resource_group_name = data.azurerm_resource_group.default.name
}

data "azurerm_user_assigned_identity" "aks-monitoring-reader" {
  name                = "aks-monitoring-reader"
  resource_group_name = data.azurerm_resource_group.default.name
}
