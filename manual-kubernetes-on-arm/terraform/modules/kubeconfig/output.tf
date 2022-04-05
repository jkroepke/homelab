output "rendered" {
  value = yamlencode(local.kubeconfig)
}
