resource "aws_ssm_parameter" "slack_webhook" {
  name      = "/${var.name_prefix}/sql-scripts/slack/webhook"
  type      = "SecureString"
  value     = var.slack_webhook_url
  overwrite = false
}
