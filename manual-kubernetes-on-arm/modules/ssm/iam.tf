resource "aws_iam_instance_profile" "this" {
  name = "${var.project}-ssm"

  role = aws_iam_role.this.name
}

data "aws_iam_policy_document" "instance-assume-role-policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "this" {
  name = "${var.project}-ssm"
  path = "/"

  assume_role_policy = data.aws_iam_policy_document.instance-assume-role-policy.json

  managed_policy_arns = [
    data.aws_iam_policy.AmazonSSMManagedInstanceCore.arn,
    data.aws_iam_policy.CloudWatchAgentServerPolicy.arn,
  ]

  inline_policy {
    name   = "ssm-s3"
    policy = data.aws_iam_policy_document.inline_policy.json
  }
}

data "aws_iam_policy_document" "inline_policy" {
  statement {
    effect  = "Allow"
    actions = ["s3:GetObject"]
    resources = [
      "arn:aws:s3:::aws-ssm-${data.aws_region.current.name}/*",
      "arn:aws:s3:::aws-windows-downloads-${data.aws_region.current.name}/*",
      "arn:aws:s3:::amazon-ssm-${data.aws_region.current.name}/*",
      "arn:aws:s3:::amazon-ssm-packages-${data.aws_region.current.name}/*",
      "arn:aws:s3:::${data.aws_region.current.name}-birdwatcher-prod/*",
      "arn:aws:s3:::aws-ssm-distributor-file-${data.aws_region.current.name}/*",
      "arn:aws:s3:::aws-ssm-document-attachments-${data.aws_region.current.name}/*",
      "arn:aws:s3:::patch-baseline-snapshot-${data.aws_region.current.name}/*"
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:PutObjectAcl",
      "s3:GetEncryptionConfiguration"
    ]
    resources = [
      "${aws_s3_bucket.this.arn}/*",
      aws_s3_bucket.this.arn
    ]
  }
}

data "aws_iam_policy" "AmazonSSMManagedInstanceCore" {
  name = "AmazonSSMManagedInstanceCore"
}

data "aws_iam_policy" "CloudWatchAgentServerPolicy" {
  name = "CloudWatchAgentServerPolicy"
}
