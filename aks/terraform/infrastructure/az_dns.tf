resource "azurerm_dns_zone" "aks_jkroepke_de" {
  name                = "aks.jkroepke.de"
  resource_group_name = azurerm_resource_group.default.name
}

module "mi-external-dns" {
  source              = "./modules/federated-managd-identity"
  name                = "external-dns"
  resource_group_name = azurerm_resource_group.default.name
  location            = azurerm_resource_group.default.location
  oidc_issuer_url     = azurerm_kubernetes_cluster.jok.oidc_issuer_url
  subject             = "system:serviceaccount:infra-external-dns:external-dns"
}

resource "azurerm_role_assignment" "dns" {
  scope                = azurerm_dns_zone.aks_jkroepke_de.id
  role_definition_name = "DNS Zone Contributor"
  principal_id         = module.mi-external-dns.principal_id
}
