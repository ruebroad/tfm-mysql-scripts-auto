resource "aws_cloudwatch_log_group" "main" {
  name              = "/aws/lambda/${aws_lambda_function.main.function_name}"
  retention_in_days = var.retention_in_days
}

resource "aws_cloudwatch_event_rule" "main" {
  name          = "${local.function_name}-s3-trigger"
  description   = "Trigger lambda on script upload"
  is_enabled    = true
  event_pattern = <<PATTERN
{
  "detail-type": [
    "AWS API Call via CloudTrail"
  ],
  "source": [
    "aws.s3"
  ],
  "detail": {
    "eventSource": [
      "s3.amazonaws.com"
    ],
    "requestParameters": {
      "bucketName": [
        "${var.script_bucket_id}"
      ]
    },
    "eventName": [
      "PutObject"
    ]
  }
}
PATTERN
}

resource "aws_cloudwatch_event_target" "lambda" {
  rule = aws_cloudwatch_event_rule.main.name
  arn  = aws_lambda_function.main.arn
}

resource "aws_lambda_permission" "main" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.main.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.main.arn
}
