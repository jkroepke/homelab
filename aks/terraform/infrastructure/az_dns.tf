data "azurerm_dns_zone" "aks_jkroepke_de" {
  name                = "aks.jkroepke.de"
  resource_group_name = "manual"
}

module "mi-external-dns" {
  source              = "./modules/federated-managed-identity"
  name                = "external-dns"
  resource_group_name = azurerm_resource_group.jok-default.name
  location            = azurerm_resource_group.jok-default.location
  oidc_issuer_url     = azurerm_kubernetes_cluster.jok.oidc_issuer_url
  subjects            = ["system:serviceaccount:infra-external-dns:external-dns"]
}

resource "azurerm_role_assignment" "dns" {
  scope                = data.azurerm_dns_zone.aks_jkroepke_de.id
  role_definition_name = "DNS Zone Contributor"
  principal_id         = module.mi-external-dns.principal_id
}
