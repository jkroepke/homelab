resource "helm_release" "this" {
  repository = "https://kubernetes.github.io/cloud-provider-aws"
  chart      = "aws-cloud-controller-manager"
  name       = "aws-cloud-controller-manager"
  namespace  = "kube-system"
  version    = "0.0.6"

  max_history     = 3
  lint            = true
  wait            = true
  atomic          = true
  cleanup_on_fail = true
  timeout         = 300

  values = [
    jsonencode({
      hostNetworking = true
      args = [
        "--v=2",
        "--cloud-provider=aws",
        "--enable-leader-migration",
        "--cluster-name=${var.cluster_name}",
        "--configure-cloud-routes=false"
      ]
    })
  ]
}
