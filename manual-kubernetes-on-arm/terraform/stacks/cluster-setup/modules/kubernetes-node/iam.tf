data "aws_iam_policy" "AmazonEC2ContainerRegistryReadOnly" {
  name = "AmazonEC2ContainerRegistryReadOnly"
}

data "aws_iam_policy" "AmazonEKS_CNI_Policy" {
  name = "AmazonEKS_CNI_Policy"
}

resource "aws_iam_policy" "user_data_s3" {
  name   = "${var.cluster_name}-nodes-user-data-s3"
  policy = data.aws_iam_policy_document.user_data_s3.json
}

data "aws_iam_policy_document" "user_data_s3" {
  statement {
    effect = "Allow"

    actions = [
      "s3:GetObject",
      "s3:ListBucket",
    ]

    resources = [
      module.user_data.bucket_arn, "${module.user_data.bucket_arn}/*"
    ]
  }
}

module "iam-instance-profile" {
  source = "../../../../modules/iam-instance-profile"

  name = "${var.cluster_name}-node"
  policy_arns = concat(var.iam_role_policy_attachments, [
    aws_iam_policy.user_data_s3.arn,
    data.aws_iam_policy.AmazonEC2ContainerRegistryReadOnly.arn,
    data.aws_iam_policy.AmazonEKS_CNI_Policy.arn,
  ])
}
