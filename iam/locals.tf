locals {
  username   = "${var.name_prefix}-bitbucket-${var.client}"
  ssm_prefix = "arn:aws:ssm:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:parameter/${var.name_prefix}/sql-scripts"
}
