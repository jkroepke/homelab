resource "aws_cloudwatch_event_rule" "this" {
  name        = var.name
  description = "Lifecycle hooks from AGS ${var.name}"

  event_pattern = jsonencode({
    source      = ["aws.autoscaling"]
    detail-type = ["EC2 Instance-launch Lifecycle Action"]
    detail = {
      AutoScalingGroupName = var.autoscale_group_names
    }
  })
}

resource "aws_cloudwatch_event_target" "example" {
  arn       = aws_lambda_function.this.arn
  target_id = "lambda"
  rule      = aws_cloudwatch_event_rule.this.id
}
