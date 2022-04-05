resource "aws_kms_key" "this" {
  description = var.name
  policy      = data.aws_iam_policy_document.kms.json

  deletion_window_in_days = 7
}

resource "aws_kms_alias" "this" {
  name          = "alias/${var.name}"
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
      identifiers = [var.iam_role_arn]
      type        = "AWS"
    }

    actions = [
      "kms:Decrypt",
      "kms:Encrypt"
    ]

    resources = ["*"]
  }
}
