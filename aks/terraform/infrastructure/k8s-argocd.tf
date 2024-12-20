resource "azureakscommand_invoke" "argocd" {
  resource_group_name = azurerm_kubernetes_cluster.jok.resource_group_name
  name                = azurerm_kubernetes_cluster.jok.name

  command = <<EOT
helm install argocd argo-cd --wait --repo https://argoproj.github.io/argo-helm --create-namespace -n argocd;
kubectl apply -n argocd -f - <<API
${file("${path.module}/../../argocd/1-bootstrap/argocd.yaml")}
API
EOT

  lifecycle {
    postcondition {
      condition     = self.exit_code == 0
      error_message = "exit code invalid"
    }
  }
}

output "output" {
  value = azureakscommand_invoke.argocd.output
}
