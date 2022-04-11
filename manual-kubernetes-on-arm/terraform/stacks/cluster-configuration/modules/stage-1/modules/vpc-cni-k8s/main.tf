data "aws_region" "current" {}

resource "helm_release" "this" {
  repository = "https://aws.github.io/eks-charts"

  chart       = "aws-vpc-cni"
  version     = var.chart_version
  name        = "aws-vpc-cni"
  namespace   = "kube-system"
  max_history = 3

  wait            = true
  atomic          = true
  cleanup_on_fail = true
  lint            = true
  timeout         = 300

  values = [
    jsonencode({
      init = {
        image = {
          # https://docs.aws.amazon.com/eks/latest/userguide/add-ons-images.html
          account = "602401143452"
          region  = data.aws_region.current.name
        }
      }
      image = {
        # https://docs.aws.amazon.com/eks/latest/userguide/add-ons-images.html
        account = "602401143452"
        region  = data.aws_region.current.name
      }
      env = {
        AWS_VPC_CNI_NODE_PORT_SUPPORT = "true"
        AWS_VPC_K8S_CNI_LOG_FILE      = "stdout"
        AWS_VPC_K8S_CNI_EXTERNALSNAT  = "true"
        AWS_VPC_K8S_PLUGIN_LOG_FILE   = "stderr"
        CLUSTER_NAME                  = var.cluster_name
        ENABLE_PREFIX_DELEGATION      = "true"

        # https://github.com/aws/amazon-eks-pod-identity-webhook
        # https://github.com/aws/amazon-vpc-cni-k8s/pull/1949
        # AWS_DEFAULT_REGION          = data.aws_region.current.name
        # AWS_REGION                  = data.aws_region.current.name
        # AWS_ROLE_ARN                = module.iam_role.role_arn
        # AWS_WEB_IDENTITY_TOKEN_FILE = "/var/run/secrets/eks.amazonaws.com/serviceaccount/token"
        # AWS_STS_REGIONAL_ENDPOINTS  = "regional"
      }
      cniConfig = {
        region = data.aws_region.current.name
      }
      cri = {
        hostPath = {
          path = "/var/run/containerd/containerd.sock"
        }
      }
      serviceAccount = {
        name = "aws-vpc-cni"
      }
      }), jsonencode({
      eniConfig = {
        create = true
        region = data.aws_region.current.name
        subnets = {
          for az in data.aws_availability_zones.available.names : replace(az, data.aws_region.current.name, "") => {
            id             = data.aws_subnet.private[az].id
            securityGroups = [data.aws_security_group.pods.id]
          }
        }
      }
    })
  ]
}

data "aws_security_group" "pods" {
  name = "${var.cluster_name}-pod"
}

data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_subnet" "private" {
  for_each = toset(data.aws_availability_zones.available.names)

  filter {
    name   = "tag:Name"
    values = ["${var.cluster_name}-private-${each.key}"]
  }
}
