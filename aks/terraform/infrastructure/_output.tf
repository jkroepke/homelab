output "aks_issuer" {
  value = azurerm_kubernetes_cluster.jok.oidc_issuer_url
}

output "dns_ns" {
  value = azurerm_dns_zone.aks_jkroepke_de.name_servers
}
