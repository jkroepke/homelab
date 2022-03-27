resource "aws_kms_key" "this" {
  description = "${var.cluster_name}-secrets"
  policy      = data.aws_iam_policy_document.kms.json

  deletion_window_in_days = 7
}

resource "aws_kms_alias" "this" {
  name          = "alias/${var.cluster_name}-secrets"
  target_key_id = aws_kms_key.this.key_id
}

data "aws_iam_policy_document" "kms" {
  statement {
    sid    = "Enable IAM User Permissions"
    effect = "Allow"
    principals {
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
      type        = "AWS"
    }

    actions = [
      "kms:*"
    ]

    resources = ["*"]
  }

  statement {
    sid    = "sns"
    effect = "Allow"
    principals {
      identifiers = [aws_iam_role.this.arn]
      type        = "AWS"
    }

    actions = [
      "kms:Decrypt",
      "kms:Encrypt"
    ]

    resources = ["*"]
  }
}
