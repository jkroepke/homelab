data "aws_iam_policy" "AmazonEC2ContainerRegistryReadOnly" {
  name = "AmazonEC2ContainerRegistryReadOnly"
}

data "aws_iam_policy" "AmazonEKS_CNI_Policy" {
  name = "AmazonEKS_CNI_Policy"
}

module "iam-instance-profile" {
  source = "../../../../modules/iam-instance-profile"

  name = "${var.cluster_name}-worker"
  policy_arns = concat(var.iam_role_policy_attachments, [
    data.aws_iam_policy.AmazonEC2ContainerRegistryReadOnly.arn,
    data.aws_iam_policy.AmazonEKS_CNI_Policy.arn,
  ])
}
