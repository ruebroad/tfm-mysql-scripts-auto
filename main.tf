module "sql_scripts" {
  source = "./sql_scripts"

  name_prefix       = var.name_prefix
  default_tags      = var.default_tags
  account_id        = var.account_id
  rds_admin_name    = var.rds_admin_name
  rds_admin_pwd     = var.rds_admin_pwd
  rds_db_endpoint   = var.rds_db_endpoint
  ssm_slack_webhook = aws_ssm_parameter.slack_webhook.name
  vpc_id            = var.vpc_id
  jira_api_token    = var.jira_api_token
  jira_base_url     = var.jira_base_url
  jira_user_email   = var.jira_user_email
  snow_svc_acc      = var.snow_svc_acc
  snow_svc_pwd      = var.snow_svc_pwd
  snow_url          = var.snow_url
}

