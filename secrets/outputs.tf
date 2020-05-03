// output "slack_webhook_arn" {
//   value = aws_ssm_parameter.slack_webhook.arn
// }

output "ssm_rds_db_endpoint" {
  value = aws_ssm_parameter.rds_db_endpoint.name
}

output "ssm_rds_admin_name" {
  value = aws_ssm_parameter.rds_admin_name.name
}

output "ssm_rds_admin_pwd" {
  value = aws_ssm_parameter.rds_admin_password.name
}

// output "ssm_slack_channel" {
//   value = aws_ssm_parameter.slack_channel.name
// }
