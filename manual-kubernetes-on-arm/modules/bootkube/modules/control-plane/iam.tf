resource "aws_iam_instance_profile" "this" {
  name = "${var.cluster_name}-controller"
  path = "/${var.cluster_name}/"
  role = aws_iam_role.this.name
}

resource "aws_iam_role" "this" {
  name               = "${var.cluster_name}-controller"
  assume_role_policy = data.aws_iam_policy_document.instance-assume-role-policy.json

  managed_policy_arns = concat([], var.iam_additional_policy_arns)
}

resource "aws_iam_policy" "this" {
  name   = "${var.cluster_name}-controller"
  policy = data.aws_iam_policy_document.this.json
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

data "aws_iam_policy_document" "this" {
  statement {
    actions   = ["ec2:Describe*"]
    effect    = "Allow"
    resources = ["*"]
  }
}
