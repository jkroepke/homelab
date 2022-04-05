data "aws_caller_identity" "current" {}

locals {
  oidc_provider_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/${var.issuer}"
}

resource "aws_iam_role" "this" {
  name                = var.name
  assume_role_policy  = data.aws_iam_policy_document.trust.json
  managed_policy_arns = [var.policy_arns]
}

data "aws_iam_policy_document" "trust" {
  statement {
    effect = "Allow"

    principals {
      identifiers = [local.oidc_provider_arn]
      type        = "Federated"
    }

    actions = ["sts:AssumeRoleWithWebIdentity"]

    condition {
      test     = "StringEquals"
      values   = ["sts.amazonaws.com"]
      variable = "${var.issuer}:aud"
    }

    condition {
      test     = "StringEquals"
      values   = var.sub
      variable = "${var.issuer}:sub"
    }
  }
}
