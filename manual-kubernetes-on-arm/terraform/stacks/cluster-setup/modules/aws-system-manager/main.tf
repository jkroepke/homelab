locals {
  ssm_documents = [
    "AWS-GatherSoftwareInventory",
    "AWS-UpdateSSMAgent",
    #"AWS-PatchInstanceWithRollback",
    #"AmazonCloudWatch-ManageAgent"
  ]

  managed_policy_arns = [
    aws_iam_policy.this.arn,
    data.aws_iam_policy.AmazonSSMManagedInstanceCore.arn,
    data.aws_iam_policy.CloudWatchAgentServerPolicy.arn,
  ]
}

resource "aws_ssm_association" "this" {
  for_each = toset(local.ssm_documents)

  name = each.key

  apply_only_at_cron_interval = false

  # https://docs.aws.amazon.com/systems-manager/latest/userguide/reference-cron-and-rate-expressions.html#reference-cron-and-rate-expressions-association
  schedule_expression = "cron(15 1 ? * * *)"

  targets {
    key    = "tag:project"
    values = [var.name]
  }
}
