resource "aws_iam_instance_profile" "worker" {
  name = "${var.cluster_name}-worker"
  path = "/${var.cluster_name}/"
  role = aws_iam_role.worker.name
}

resource "aws_iam_role" "worker" {
  name               = "${var.cluster_name}-worker"
  assume_role_policy = data.aws_iam_policy_document.instance-assume-role-policy.json

  managed_policy_arns = concat([], var.iam_additional_policy_arns)
}

resource "aws_iam_policy" "worker" {
  name   = "${var.cluster_name}-worker"
  policy = data.aws_iam_policy_document.worker.json
}

data "aws_iam_policy_document" "worker" {
  statement {
    actions   = ["ec2:Describe*"]
    effect    = "Allow"
    resources = ["*"]
  }
}
