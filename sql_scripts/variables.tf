variable "default_tags" {
  type = map
}
variable "name_prefix" {}
// variable "clients" {
//   type = list
// }
variable "rds_admin_name" {
  type = map
}
variable "rds_admin_pwd" {}
variable "rds_db_endpoint" {
  type = map
}
variable "account_id" {}
variable "ssm_slack_webhook" {}
variable "vpc_id" {
  type = map
}

variable "jira_api_token" {}
variable "jira_base_url" {}
variable "jira_user_email" {}

variable "snow_svc_acc" {}
variable "snow_svc_pwd" {}
variable "snow_url" {
  type = map
}
