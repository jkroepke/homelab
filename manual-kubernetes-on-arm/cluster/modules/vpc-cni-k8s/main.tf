data "aws_region" "current" {}

resource "helm_release" "this" {
  repository = "https://aws.github.io/eks-charts"

  chart = "aws-vpc-cni"
  name  = "aws-vpc-cni"

  namespace = "kube-system"

  values = [yamlencode({
    init = {
      region = data.aws_region.current.name
    }
    image = {
      region = data.aws_region.current.name
    }
    env =  {
      AWS_VPC_K8S_CNI_EXTERNALSNAT = "true"
      ENABLE_PREFIX_DELEGATION = "true"
    }
    cniConfig = {
      region = data.aws_region.current.name
      subnets = {
        id =
        securityGroups =
      }
    }
    cri = {
      hostPath = {
        path = "/var/run/containerd/containerd.sock"
      }
    }
  })]
}
