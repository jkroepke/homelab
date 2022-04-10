resource "helm_release" "this" {
  repository = "https://docs.projectcalico.org/charts"
  chart      = "tigera-operator"
  name       = "tigera-operator"
  namespace  = "kube-system"
  version    = var.chart_version

  max_history     = 3
  lint            = true
  wait            = true
  atomic          = true
  cleanup_on_fail = true
  timeout         = 300


  values = [jsonencode({
    installation = {
      flexVolumePath = "/opt/libexec/kubernetes/kubelet-plugins/volume/exec/"
    }
  })]
}

