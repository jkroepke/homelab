resource "aws_iam_policy_attachment" "fargate-logging" {
  name       = "fargate-logging"
  roles      = [module.eks.fargate_profiles["default"].iam_role_name]
  policy_arn = aws_iam_policy.fargate-logging.arn
}

resource "aws_iam_policy" "fargate-logging" {
  name        = "${local.cluster_name}-fargate-logging"
  description = "A test policy"

  policy = <<EOF
{
	"Version": "2012-10-17",
	"Statement": [{
		"Effect": "Allow",
		"Action": [
			"logs:CreateLogStream",
			"logs:CreateLogGroup",
			"logs:DescribeLogStreams",
			"logs:PutLogEvents"
		],
		"Resource": "*"
	}]
}
EOF
}
