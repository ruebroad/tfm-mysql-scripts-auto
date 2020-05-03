module "s3" {
  source = "../s3"

  name_prefix  = var.name_prefix
  account_id   = var.account_id
  default_tags = var.default_tags
  client       = "xxx"
}

module "secrets" {
  source = "../secrets"

  name_prefix     = var.name_prefix
  default_tags    = var.default_tags
  client          = "rbc"
  rds_admin_name  = var.rds_admin_name
  rds_admin_pwd   = var.rds_admin_pwd
  rds_db_endpoint = var.rds_db_endpoint
}

module "lambda" {
  source = "../lambda"

  name_prefix       = var.name_prefix
  default_tags      = var.default_tags
  client            = "rbc"
  script_bucket_arn = module.s3.script_bucket_arn
  script_bucket_id  = module.s3.script_bucket_id
  vpc_id            = var.vpc_id[terraform.workspace]

  ssm_rds_admin_name  = module.secrets.ssm_rds_admin_name
  ssm_rds_admin_pwd   = module.secrets.ssm_rds_admin_pwd
  ssm_rds_db_endpoint = module.secrets.ssm_rds_db_endpoint
  ssm_slack_webhook   = var.ssm_slack_webhook
  // ssm_slack_channel   = module.secrets.ssm_slack_channel

  jira_api_token  = var.jira_api_token
  jira_base_url   = var.jira_base_url
  jira_user_email = var.jira_user_email
  snow_svc_acc    = var.snow_svc_acc
  snow_svc_pwd    = var.snow_svc_pwd
  snow_url        = var.snow_url[terraform.workspace]
}

module "iam" {
  source = "../iam"

  name_prefix       = var.name_prefix
  client            = "rbc"
  script_bucket_arn = module.s3.script_bucket_arn
}
