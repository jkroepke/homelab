resource "aws_iam_instance_profile" "worker" {
  name = "worker"
  role = aws_iam_role.worker.name
}

resource "aws_iam_role" "worker" {
  name               = "${var.name}-worker"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.assume-role.json
}

resource "aws_iam_policy_attachment" "worker" {
  name       = "${var.name}-worker"
  roles      = [
    aws_iam_role.worker.name
  ]
  policy_arn = aws_iam_policy.worker.arn
}

resource "aws_iam_policy" "worker" {
  name   = "${var.name}-worker"
  path   = "/"
  policy = data.aws_iam_policy_document.worker.json
}

data "aws_iam_policy_document" "worker" {
  # https://github.com/kubernetes/cloud-provider-aws#iam-policy
  statement {
    sid = "1"
    actions =  [
      "ec2:DescribeInstances",
      "ec2:DescribeRegions",
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:GetRepositoryPolicy",
      "ecr:DescribeRepositories",
      "ecr:ListImages",
      "ecr:BatchGetImage"
    ]

    resources = ["*"]
  }

  # https://github.com/kubernetes-sigs/aws-ebs-csi-driver/blob/master/docs/example-iam-policy.json
  statement {
    actions = [
      "ec2:AttachVolume",
      "ec2:CreateSnapshot",
      "ec2:CreateTags",
      "ec2:CreateVolume",
      "ec2:DeleteSnapshot",
      "ec2:DeleteTags",
      "ec2:DeleteVolume",
      "ec2:DescribeAvailabilityZones",
      "ec2:DescribeInstances",
      "ec2:DescribeSnapshots",
      "ec2:DescribeTags",
      "ec2:DescribeVolumes",
      "ec2:DescribeVolumesModifications",
      "ec2:DetachVolume",
      "ec2:ModifyVolume"
    ]

    resources = ["*"]
  }
}
