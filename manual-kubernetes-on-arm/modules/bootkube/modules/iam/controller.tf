resource "aws_iam_instance_profile" "controller" {
  name = "${var.cluster_name}-controller"
  path = "/${var.cluster_name}/"
  role = aws_iam_role.controller.name
}

resource "aws_iam_role" "controller" {
  name               = "${var.cluster_name}-controller"
  assume_role_policy = data.aws_iam_policy_document.instance-assume-role-policy.json

  managed_policy_arns = concat([], var.iam_additional_policy_arns)
}

resource "aws_iam_policy" "controller" {
  name   = "${var.cluster_name}-controller"
  policy = data.aws_iam_policy_document.controller.json
}

data "aws_iam_policy_document" "controller" {
  statement {
    actions   = ["ec2:Describe*"]
    effect    = "Allow"
    resources = ["*"]
  }
}
