data "aws_region" "current" {}

resource "helm_release" "this" {
  chart      = "kubelet-csr-approver"
  name       = "kubelet-csr-approver"
  repository = "https://postfinance.github.io/kubelet-csr-approver"
  version    = "0.2.1"
  namespace  = "kube-system"

  max_history     = 3
  lint            = true
  wait            = true
  atomic          = true
  cleanup_on_fail = true
  timeout         = 300

  values = [
    jsonencode({
      dnsPolicy     = "Default"
      providerRegex = "^i-\\w+(\\.${data.aws_region.current.name}\\.compute\\.internal)?$"

      tolerations = [
        {
          key    = "node-role.kubernetes.io/master"
          effect = "NoSchedule"
        }
      ]
    })
  ]
}
