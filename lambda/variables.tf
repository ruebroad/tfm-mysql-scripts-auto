variable "vpc_id" {}
variable "default_tags" {
  type = map
}
variable "name_prefix" {}
variable "client" {
}
variable "retention_in_days" {
  default = 3
}

variable "script_bucket_arn" {}
variable "script_bucket_id" {}
variable "ssm_rds_admin_name" {}
variable "ssm_rds_admin_pwd" {}
variable "ssm_rds_db_endpoint" {}
variable "ssm_slack_webhook" {}
variable "db_name" {
  default = "opamerge"
}
// variable "ssm_slack_channel" {}
variable "rds_port" {
  default = 3306
}

// Lambda variables
variable "runtime" {
  default = "python3.8"
}
variable "handler" {
  default = "sql-scripts.lambda_handler"
}
variable "memory_size" {
  default = 128
}
variable "timeout" {
  default = 15
}

// Jira variables
variable "jira_api_token" {}
variable "jira_base_url" {}
variable "jira_user_email" {}

# ServiceNow variables
variable "snow_svc_acc" {}
variable "snow_svc_pwd" {}
variable "snow_url" {}
