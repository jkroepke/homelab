output "aks_issuer" {
  value = azurerm_kubernetes_cluster.jok.oidc_issuer_url
}

output "dns_ns" {
  value = azurerm_dns_zone.aks_jkroepke_de.name_servers
}

output "bastion_ip4" {
  value = azurerm_public_ip.bastion["4"].ip_address
}

output "bastion_ip6" {
  value = azurerm_public_ip.bastion["6"].ip_address
}
