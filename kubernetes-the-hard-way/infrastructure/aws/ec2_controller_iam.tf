data "aws_iam_policy_document" "kubernetes-controller" {
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
}

resource "aws_iam_policy" "kubernetes-controller" {
  name   = "${var.name}-kubernetes-controller"
  path   = "/"
  policy = data.aws_iam_policy_document.kubernetes-controller.json
}

resource "aws_iam_role" "kubernetes-controller" {
  name               = "${var.name}-kubernetes-controller"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.assume-role.json
}

resource "aws_iam_policy_attachment" "kubernetes-controller" {
  name       = "${var.name}-kubernetes-controller"
  roles      = [aws_iam_role.kubernetes-controller.name]
  policy_arn = aws_iam_policy.kubernetes-controller.arn
}

resource "aws_iam_instance_profile" "kubernetes-controller" {
  name = "kubernetes-controller"
  role = aws_iam_role.kubernetes-controller.name
}

