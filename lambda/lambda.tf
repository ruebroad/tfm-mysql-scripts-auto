

resource "aws_lambda_function" "main" {
  filename         = data.archive_file.source.output_path
  role             = aws_iam_role.main.arn
  source_code_hash = data.archive_file.source.output_base64sha256

  runtime       = var.runtime
  handler       = var.handler
  description   = "Lambda Automation for SQL Scripts"
  function_name = local.function_name
  memory_size   = var.memory_size
  timeout       = var.timeout


  dynamic "environment" {
    for_each = local.environment // == null ? [] : [local.environment]
    content {
      variables = environment.value.variables
    }
  }

  vpc_config {
    security_group_ids = [aws_security_group.main.id]
    subnet_ids         = data.aws_subnet_ids.rds.ids
  }


  tags = merge(
    var.default_tags,
    map(
      "Name", local.function_name,
      "Workspace", terraform.workspace
    )
  )

  lifecycle {
    ignore_changes = [filename]
  }
}


