data "aws_iam_policy_document" "kubernetes-worker" {
  statement {
    sid = "1"
    actions = [
      "ec2:DescribeInstance*",
      "ec2:DescribeTags"
    ]

    resources = ["*"]
  }
}

resource "aws_iam_policy" "kubernetes-worker" {
  name   = "${var.name}-kubernetes-worker"
  path   = "/"
  policy = data.aws_iam_policy_document.kubernetes-worker.json
}

resource "aws_iam_role" "kubernetes-worker" {
  name               = "${var.name}-kubernetes-worker"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.assume-role.json
}

resource "aws_iam_policy_attachment" "kubernetes-worker" {
  name       = "${var.name}-kubernetes-worker"
  roles      = [aws_iam_role.kubernetes-worker.name]
  policy_arn = aws_iam_policy.kubernetes-worker.arn
}

resource "aws_iam_instance_profile" "kubernetes-worker" {
  name = "kubernetes-worker"
  role = aws_iam_role.kubernetes-worker.name
}

