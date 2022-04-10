resource "kubernetes_namespace" "this" {
  metadata {
    name = "karpenter"
  }
}

resource "helm_release" "this" {
  repository = "https://charts.karpenter.sh"
  chart      = "karpenter"
  name       = "karpenter"
  namespace  = kubernetes_namespace.this.metadata[0].name
  version    = "v0.8.1"

  max_history     = 3
  lint            = true
  wait            = true
  atomic          = true
  cleanup_on_fail = true
  timeout         = 600

  values = [
    jsonencode({
      nodeSelector = {
        "node-role.kubernetes.io/master" = ""
      }

      tolerations = [
        {
          key    = "node-role.kubernetes.io/master"
          effect = "NoSchedule"
        }
      ]

      controller = {
        env = [
          {
            name  = "AWS_NODE_NAME_CONVENTION"
            value = "resource-name"
          }
        ]
        resources = {
          requests = {
            cpu    = "100m"
            memory = "250Mi"
          }
        }
      }
    })
  ]

  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = module.iam-role-for-service-account.role_arn
  }

  set {
    name  = "clusterName"
    value = var.cluster_name
  }

  set {
    name  = "controller.logLevel"
    value = "info"
  }

  set {
    name  = "logLevel"
    value = "info"
  }

  set {
    name  = "clusterEndpoint"
    value = var.kubernetes_api_server
  }

  set {
    name  = "aws.defaultInstanceProfile"
    value = "${var.cluster_name}-worker"
  }
}

module "iam-role-for-service-account" {
  source      = "../../../../modules/iam-role-for-service-account"
  issuer      = replace(var.kubernetes_api_server, "https://", "")
  name        = "${var.cluster_name}-karpenter"
  policy_json = data.aws_iam_policy_document.this.json

  sub = ["system:serviceaccount:karpenter:karpenter"]
}

data "aws_iam_policy_document" "this" {
  statement {
    effect = "Allow"
    actions = [
      "ec2:CreateLaunchTemplate",
      "ec2:CreateFleet",
      "ec2:RunInstances",
      "ec2:CreateTags",
      "iam:PassRole",
      "ec2:TerminateInstances",
      "ec2:DescribeLaunchTemplates",
      "ec2:DeleteLaunchTemplate",
      "ec2:DescribeInstances",
      "ec2:DescribeSecurityGroups",
      "ec2:DescribeSubnets",
      "ec2:DescribeInstanceTypes",
      "ec2:DescribeInstanceTypeOfferings",
      "ec2:DescribeAvailabilityZones",
      "ssm:GetParameter"
    ]
    resources = ["*"]
  }
}
