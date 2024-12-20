resource "azureakscommand_invoke" "argocd" {
  resource_group_name = azurerm_kubernetes_cluster.jok.resource_group_name
  name                = azurerm_kubernetes_cluster.jok.name

  command = <<-EOT
  helm install argocd argo-cd --wait --repo https://argoproj.github.io/argo-helm --create-namespace -n argocd
  k apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
  EOT

  lifecycle {
    postcondition {
      condition     = self.exit_code == 0
      error_message = "exit code invalid"
    }
  }
}
