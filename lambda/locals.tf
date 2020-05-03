locals {
  prefix        = "${var.name_prefix}-sql-scripts-lambda"
  function_name = "${var.name_prefix}-sql-scripts-${var.client}"
  ssm_prefix    = "arn:aws:ssm:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:parameter/${var.name_prefix}/sql-scripts"

  build_command = "${path.module}/pip.sh ${path.module}/code"
  source_dir    = "${path.module}/code"
  output_path   = "${path.module}/output/sql-scripts.zip"

  build_triggers = {
    requirements = "${base64sha256(file("${path.module}/requirements.txt"))}"
    execute      = "${base64sha256(file("${path.module}/pip.sh"))}"
  }

  environment = [{
    variables = {
      "REGION"           = data.aws_region.current.name,
      "SQL_USERNAME"     = var.ssm_rds_admin_name,
      "SQL_PASSWORD"     = var.ssm_rds_admin_pwd,
      "RDS_DNS_NAME"     = var.ssm_rds_db_endpoint,
      "DB_NAME"          = var.db_name,
      "SLACK_WEBHOOK"    = var.ssm_slack_webhook,
      "SLACK_CHANNEL"    = "bb-${var.client}-sql",
      "SECRET_NAME"      = "SecretManagerSupportToBeAdded",
      "JIRA_BASE_URL"    = var.jira_base_url,
      "JIRA_USER_EMAIL"  = var.jira_user_email,
      "JIRA_API_TOKEN"   = var.jira_api_token,
      "TRANSITION"       = "Done",
      "SNOW_SVC_ACC"     = var.snow_svc_acc,
      "SNOW_SVC_PWD"     = var.snow_svc_pwd,
      "SNOW_CR_SSM_PATH" = "${var.name_prefix}/sql-scripts/${var.client}/issues",
      "SNOW_URL"         = var.snow_url
    }
  }]
}


