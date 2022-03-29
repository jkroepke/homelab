resource "aws_iam_role_policy_attachment" "amazon_vpc_cni_k8s" {
  policy_arn = aws_iam_policy.amazon_vpc_cni_k8s.arn
  role       = aws_iam_role.this.name
}

resource "aws_iam_policy" "amazon_vpc_cni_k8s" {
  name        = "${var.cluster_name}-amazon-vpc-cni-k8s"
  path        = "/${var.cluster_name}/kubernetes/"
  policy      = data.aws_iam_policy_document.amazon_vpc_cni_k8s.json
  description = "https://github.com/aws/amazon-vpc-cni-k8s/blob/master/docs/iam-policy.md"
}

data "aws_iam_policy_document" "amazon_vpc_cni_k8s" {
  statement {
    actions = [
      "ec2:AssignPrivateIpAddresses",
      "ec2:AttachNetworkInterface",
      "ec2:CreateNetworkInterface",
      "ec2:DeleteNetworkInterface",
      "ec2:DescribeInstances",
      "ec2:DescribeInstanceTypes",
      "ec2:DescribeTags",
      "ec2:DescribeNetworkInterfaces",
      "ec2:DetachNetworkInterface",
      "ec2:ModifyNetworkInterfaceAttribute",
      "ec2:UnassignPrivateIpAddresses"
    ]
    effect    = "Allow"
    resources = ["*"]
  }
  statement {
    actions = [
      "ec2:CreateTags"
    ]
    effect    = "Allow"
    resources = ["arn:aws:ec2:*:*:network-interface/*"]
  }
  statement {
    actions = [
      "ec2:AssignIpv6Addresses",
    ]
    effect    = "Allow"
    resources = ["*"]
  }
}
