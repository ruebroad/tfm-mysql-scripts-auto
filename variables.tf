// Variables

variable "region" {
  default = "eu-west-1"
}

variable "name_prefix" {
  default = "l320"
}

variable "account_id" {}

variable "default_tags" {
  description = "Map of tags to add to all resources"
  type        = map

  default = {
    Terraform = "true"
  }
}

// Cross Account role to Assume when deploying 
variable "tfm_adm_iam_role" {
  default = "xops-tfm-adm-x-acc-role"
}

// Secrets Manager / SSM
variable "slack_webhook_url" {}
variable "rds_admin_name" {
  type = map
}
variable "rds_admin_pwd" {
  default = "change_me"
}
variable "rds_db_endpoint" {
  type = map
}

// Remote State Bucket
variable "remote_state_s3" {
  description = "S3 bucket name holding the Terraform remote state file"
  default     = "tfm-state-XXX282490297"
}

// VPC
variable "vpc_id" {
  type = map
  default = {
    dev = "vpc-b1e26cd5"
    tst = ""
    acc = ""
    prd = ""
  }
}

// Jira 
variable "jira_api_token" {}
variable "jira_base_url" {
  default = "https://mycompany.atlassian.net"
}
variable "jira_user_email" {
  default = "rbroad@ohpen.com"
}

# ServiceNow variables
variable "snow_svc_acc" {}
variable "snow_svc_pwd" {}
variable "snow_url" {
  type = map
  default = {
    dev = "https://mycompany.service-now.com"
    tst = "https://mycompany.service-now.com"
    acc = "https://mycompany.service-now.com"
    prd = "https://mycompany.service-now.com"
  }
}
