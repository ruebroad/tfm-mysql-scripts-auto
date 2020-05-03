resource "aws_ssm_parameter" "rds_db_endpoint" {
  name      = "/${local.prefix}/${var.client}/rds_dns_name"
  type      = "SecureString"
  value     = var.rds_db_endpoint[var.client]
  overwrite = false
}

resource "aws_ssm_parameter" "rds_admin_name" {
  name      = "/${local.prefix}/${var.client}/script_admin_name"
  type      = "SecureString"
  value     = var.rds_admin_name[var.client]
  overwrite = false

  lifecycle {
    ignore_changes = [description]
  }
}

resource "aws_ssm_parameter" "rds_admin_password" {
  name      = "/${local.prefix}/${var.client}/script_admin_pwd"
  type      = "SecureString"
  value     = var.rds_admin_pwd
  overwrite = false

  lifecycle {
    ignore_changes = [value, description]
  }
}

// resource "aws_ssm_parameter" "slack_channel" {
//   name      = "/${local.prefix}/${var.client}/slack_channel"
//   type      = "SecureString"
//   value     = local.slack_channel
//   overwrite = false

//   lifecycle {
//     ignore_changes = [description]
//   }
// }
