resource "aws_iam_instance_profile" "controller" {
  name = "controller"
  role = aws_iam_role.controller.name
}

resource "aws_iam_role" "controller" {
  name               = "${var.name}-controller"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.assume-role.json
}

resource "aws_iam_policy_attachment" "controller" {
  name       = "${var.name}-controller"
  roles      = [
    aws_iam_role.controller.name
  ]
  policy_arn = aws_iam_policy.controller.arn
}

resource "aws_iam_policy" "controller" {
  name   = "${var.name}-controller"
  path   = "/"
  policy = data.aws_iam_policy_document.controller.json
}

data "aws_iam_policy_document" "controller" {
  statement {
    sid = "1"
    actions = [
      "ec2:CreateTags",
      "ec2:DescribeInstance*",
      "ec2:DescribeVolume*",
      "ec2:CreateVolume",
      "ec2:AttachVolume",
      "ec2:DetachVolume",
      "ec2:DeleteVolume",
      "ec2:DescribeSubnets",
    ]

    resources = ["*"]
  }

  statement {
    actions = [
      "s3:GetObject",
    ]

    resources = [
      "${aws_s3_bucket.bootstrap.arn}/controller/*"
    ]
  }
}
