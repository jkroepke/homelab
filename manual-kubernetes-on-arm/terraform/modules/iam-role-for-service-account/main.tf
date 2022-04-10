data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

locals {
  oidc_provider_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/${var.issuer}"
}

resource "aws_iam_role" "this" {
  name               = var.name
  assume_role_policy = data.aws_iam_policy_document.trust.json
}

resource "aws_iam_role_policy_attachment" "this" {
  count = length(var.policy_arns)

  policy_arn = var.policy_arns[count.index]
  role       = aws_iam_role.this.name
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

resource "aws_iam_role_policy" "this" {
  count = var.create_policy == true ? 1 : 0

  name   = var.name
  policy = var.policy_json
  role   = aws_iam_role.this.id
}
