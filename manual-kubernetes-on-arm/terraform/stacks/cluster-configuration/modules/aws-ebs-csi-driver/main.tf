data "aws_region" "current" {}

resource "helm_release" "this" {
  repository = "https://kubernetes-sigs.github.io/aws-ebs-csi-driver"
  chart      = "aws-ebs-csi-driver"
  name       = "aws-ebs-csi-driver"
  namespace  = "kube-system"
  version    = "2.6.4"

  max_history     = 3
  lint            = true
  wait            = true
  atomic          = true
  cleanup_on_fail = true
  timeout         = 300

  values = [
    jsonencode({
      controller = {
        serviceAccount = {
          name = "aws-ebs-csi-driver"
          annotations = {
            "eks.amazonaws.com/role-arn" : module.iam-role-for-service-account.role_arn
          }
        }

        extraVolumeTags = {
          project = var.cluster_name
        }
        region          = data.aws_region.current.name
        k8sTagClusterId = var.cluster_name
        resources = {
          limits = {
            cpu    = "100m"
            memory = "128Mi"
          }
        }

        tolerations = [
          {
            key    = "node-role.kubernetes.io/master"
            effect = "NoSchedule"
          }
        ]
      }

      node = {
        tolerateAllTaints = true
      }

      storageClasses = [{
        name = "aws-ebs"
        annotations = {
          "storageclass.kubernetes.io/is-default-class" = "true"
        }
        allowVolumeExpansion = true
        volumeBindingMode    = "WaitForFirstConsumer"
        parameters = {
          encrypted = "true"
        }
      }]
    })
  ]
}

module "iam-role-for-service-account" {
  source      = "../../../../modules/iam-role-for-service-account"
  issuer      = replace(var.kubernetes_api_server, "https://", "")
  name        = "${var.cluster_name}-aws-ebs-csi-driver"
  policy_json = file("${path.module}/resources/iam-policy.json")

  sub = ["system:serviceaccount:kube-system:aws-ebs-csi-driver"]
}
