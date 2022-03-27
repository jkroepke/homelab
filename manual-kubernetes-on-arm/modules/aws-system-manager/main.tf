locals {
  documents = [
    "AWS-GatherSoftwareInventory",
    "AWS-UpdateSSMAgent",
    #"AWS-PatchInstanceWithRollback",
    #"AmazonCloudWatch-ManageAgent"
  ]
}

resource "aws_ssm_association" "this" {
  for_each = toset(local.documents)

  name = each.key

  apply_only_at_cron_interval = false

  # https://docs.aws.amazon.com/systems-manager/latest/userguide/reference-cron-and-rate-expressions.html#reference-cron-and-rate-expressions-association
  schedule_expression = "cron(15 1 ? * * *)"

  targets {
    key    = "tag:project"
    values = [var.name]
  }
}
