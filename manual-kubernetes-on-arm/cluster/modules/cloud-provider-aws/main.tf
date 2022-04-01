resource "helm_release" "this" {
  repository = "helm repo add aws-cloud-controller-manager "
  chart = "aws-cloud-controller-manager"
  name  = "aws-cloud-controller-manager"
  version = "0.0.6"

  namespace = "kube-system"

  lint = true
  wait = true
  atomic = true
  timeout = 300

  values = [jsonencode({

  })]
}
