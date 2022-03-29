resource "aws_iam_instance_profile" "this" {
  name = "${var.cluster_name}-controller"
  path = "/${var.cluster_name}/kubernetes/"
  role = aws_iam_role.this.name
}

resource "aws_iam_role" "this" {
  name               = "${var.cluster_name}-controller"
  path               = "/${var.cluster_name}/kubernetes/"
  assume_role_policy = data.aws_iam_policy_document.instance-assume-role-policy.json
}

resource "aws_iam_role_policy_attachment" "this" {
  for_each = toset(var.additional_policy_arns)

  policy_arn = each.key
  role       = aws_iam_role.this.name
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

