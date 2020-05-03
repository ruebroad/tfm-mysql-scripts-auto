// Create a security group for the lambda function
resource "aws_security_group" "main" {
  name        = "${local.prefix}-${var.client}"
  description = "Lambda Security Group"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.default_tags, map(
    "Name", "${local.prefix}-${var.client}",
    "Environment", terraform.workspace
  ))
}

// Update the AuroraSG group with a rule to allow the Lambda SG
resource "aws_security_group_rule" "lambda" {
  type                     = "ingress"
  from_port                = var.rds_port
  to_port                  = var.rds_port
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.main.id

  security_group_id = data.aws_security_group.aurora_sg.id
}
