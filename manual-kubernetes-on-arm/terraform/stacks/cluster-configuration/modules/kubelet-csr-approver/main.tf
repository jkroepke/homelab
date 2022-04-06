resource "helm_release" "this" {
  chart      = "kubelet-csr-approver"
  name       = "kubelet-csr-approver"
  repository = "https://postfinance.github.io/kubelet-csr-approver"
  version    = "0.1.2"

  lint    = true
  wait    = true
  atomic  = true
  timeout = 300

  namespace   = "kube-system"
  max_history = 10

  values = [jsonencode({
    providerRegex = "^i-\\w+$"

    tolerations = [
      {
        key    = "node-role.kubernetes.io/master"
        effect = "NoSchedule"
      }
    ]
  })]
}
