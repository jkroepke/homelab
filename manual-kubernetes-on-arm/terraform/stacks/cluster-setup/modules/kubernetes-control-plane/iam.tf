data "aws_iam_policy" "AmazonEC2ContainerRegistryReadOnly" {
  name = "AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_iam_policy" "user_data_s3" {
  name   = "${var.cluster_name}-controllers-user-data-s3"
  policy = data.aws_iam_policy_document.user_data_s3.json
}

data "aws_iam_policy_document" "user_data_s3" {
  statement {
    effect = "Allow"

    actions = [
      "s3:GetObject",
      "s3:ListBucket",
    ]

    resources = flatten([
      for index in keys(local.kubernetes_controllers) : [
        module.controller_user_data[index].bucket_arn, "${module.controller_user_data[index].bucket_arn}/*"
      ]
    ])
  }
}

module "iam-instance-profile" {
  source = "../../../../modules/iam-instance-profile"

  name = var.cluster_name
  policy_arns = concat(var.iam_role_policy_attachments, [
    aws_iam_policy.user_data_s3.arn,
    data.aws_iam_policy.AmazonEC2ContainerRegistryReadOnly.arn
  ])
}
