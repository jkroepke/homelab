resource "helm_release" "this" {
  repository = "https://kubernetes-sigs.github.io/external-dns/"
  chart      = "external-dns"
  name       = "external-dns"
  version    = var.chart_version
  namespace  = "kube-system"

  max_history     = 3
  lint            = true
  wait            = true
  atomic          = true
  cleanup_on_fail = true
  timeout         = 300

  values = [
    jsonencode({
      provider = "aws"
      serviceAccount = {
        name = "external-dns"
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

      domainFilters = [replace(var.kubernetes_api_server, "https://api.", "apps.")]
      extraArgs     = ["--aws-zone-type=public", "--txt-owner-id=${var.cluster_name}"]
    })
  ]
}

module "iam-role-for-service-account" {
  source        = "../../../../../../modules/iam-role-for-service-account"
  issuer        = replace(var.kubernetes_api_server, "https://", "")
  name          = "${var.cluster_name}-external-dns"
  create_policy = true
  policy_json   = file("${path.module}/resources/iam-policy.json")

  sub = ["system:serviceaccount:kube-system:external-dns"]
}
