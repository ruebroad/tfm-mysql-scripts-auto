data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

resource "null_resource" "build" {
  count = local.build_command != "" ? 1 : 0

  triggers = local.build_triggers

  provisioner "local-exec" {
    command = local.build_command
  }
}

# Trick to run the build command before archiving.
# See below for more detail.
# https://github.com/terraform-providers/terraform-provider-archive/issues/11
data "null_data_source" "build_dep" {
  inputs = {
    build_id   = length(null_resource.build) > 0 ? null_resource.build[0].id : ""
    source_dir = local.source_dir
  }
}

data "archive_file" "source" {
  type        = "zip"
  source_dir  = data.null_data_source.build_dep.outputs.source_dir
  output_path = local.output_path
}

data "aws_subnet_ids" "rds" {
  vpc_id = var.vpc_id

  filter {
    name   = "tag:Name"
    values = ["ssvcprivate*"] # insert values here
  }
}

data "aws_security_group" "aurora_sg" {
  vpc_id = var.vpc_id

  filter {
    name   = "tag:Name"
    values = ["*pod01-auroraSG"] # insert values here
  }
}
