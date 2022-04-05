resource "aws_cloudwatch_log_group" "this" {
  name              = "/aws/lambda/${var.name}"
  retention_in_days = 1
}

resource "aws_lambda_function" "this" {
  function_name    = var.name
  filename         = data.archive_file.this.output_path
  role             = aws_iam_role.lambda.arn
  handler          = "main.lambda_handler"
  runtime          = "python3.9"
  source_code_hash = data.archive_file.this.output_base64sha256
  description      = "Handles DNS for autoscaling groups by receiving autoscaling notifications and setting/deleting records from route53"
  timeout          = 60

  depends_on = [aws_cloudwatch_log_group.this, aws_iam_role_policy.lambda]
}

resource "aws_lambda_permission" "this" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.this.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.this.arn
}

data "archive_file" "this" {
  type = "zip"

  dynamic "source" {
    for_each = toset(fileset("${path.module}/resources", "**/*.py"))

    content {
      content  = file("${path.module}/resources/${source.value}")
      filename = source.value
    }
  }

  output_path = "${path.module}/resources/dist/autoscale.zip"
}
