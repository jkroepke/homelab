resource "helm_release" "this" {
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  name       = "aws-load-balancer-controller"
  version    = "1.4.1"
  namespace  = "kube-system"

  max_history     = 3
  lint            = true
  atomic          = true
  cleanup_on_fail = true
  timeout         = 300

  values = [
    jsonencode({
      enableCertManager = true
      clusterName       = var.cluster_name
      defaultSSLPolicy  = "ELBSecurityPolicy-FS-1-2-Res-2020-10"
      serviceAcount = {
        name = "aws-load-balancer-controller"
        annotations = {
          "eks.amazonaws.com/role-arn" : module.iam-role-for-service-account.role_arn
        }
      }
      tolerations = [
        {
          key    = "node-role.kubernetes.io/master"
          effect = "NoSchedule"
        }
      ]
    })
  ]
}

module "iam-role-for-service-account" {
  source      = "../../../../modules/iam-role-for-service-account"
  issuer      = replace(var.kubernetes_api_server, "https://", "")
  name        = "${var.cluster_name}-aws-load-balancer-controller"
  policy_json = file("${path.module}/resources/iam-policy.json")

  sub = ["system:serviceaccount:kube-system:aws-load-balancer-controller"]
}
