output "aks_issuer" {
  value = azurerm_kubernetes_cluster.jok.oidc_issuer_url
}
