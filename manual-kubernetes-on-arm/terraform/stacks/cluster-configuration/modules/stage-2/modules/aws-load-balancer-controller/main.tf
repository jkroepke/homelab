resource "helm_release" "this" {
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  name       = "aws-load-balancer-controller"
  namespace  = "kube-system"
  version    = var.chart_version

  max_history     = 3
  lint            = true
  wait            = true
  atomic          = true
  cleanup_on_fail = true
  timeout         = 300

  values = [
    jsonencode({
      enableCertManager = true
      clusterName       = var.cluster_name
      defaultSSLPolicy  = "ELBSecurityPolicy-FS-1-2-Res-2020-10"

      defaultTags = {
        project = var.cluster_name
      }

      nodeSelector = {
        role = "infra"
      }

      tolerations = [
        {
          key    = "node-role.kubernetes.io/infra"
          effect = "NoSchedule"
        }
      ]

      env               = module.iam-role-for-service-account.kubernetes_config_env_flat
      extraVolumeMounts = module.iam-role-for-service-account.kubernetes_config_extra_volume_mounts
      extraVolumes      = module.iam-role-for-service-account.kubernetes_config_extra_volumes
    })
  ]
}

module "iam-role-for-service-account" {
  source        = "../../../../../../modules/iam-role-for-service-account"
  issuer        = replace(var.kubernetes_api_server, "https://", "")
  name          = "${var.cluster_name}-aws-load-balancer-controller"
  create_policy = true
  policy_json   = file("${path.module}/resources/iam-policy.json")

  sub = ["system:serviceaccount:kube-system:aws-load-balancer-controller"]
}
