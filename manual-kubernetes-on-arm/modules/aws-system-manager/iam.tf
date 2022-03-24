resource "aws_iam_instance_profile" "this" {
  name = "${var.name}-ssm"
  path = "/${var.name}/"
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
  name = "${var.name}-ssm"
  path = "/${var.name}/"

  assume_role_policy  = data.aws_iam_policy_document.instance-assume-role-policy.json
  managed_policy_arns = [aws_iam_policy.this.arn]
}

resource "aws_iam_policy" "this" {
  name   = "${var.name}-ssm"
  path   = "/${var.name}/"
  policy = data.aws_iam_policy_document.ssm.json
}

data "aws_iam_policy_document" "s3-ssm" {
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

data "aws_iam_policy_document" "ssm" {
  source_policy_documents = [
    data.aws_iam_policy.AmazonSSMManagedInstanceCore.policy,
    data.aws_iam_policy.CloudWatchAgentServerPolicy.policy,
    data.aws_iam_policy_document.s3-ssm.json
  ]
}
