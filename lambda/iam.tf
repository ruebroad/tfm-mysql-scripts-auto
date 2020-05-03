resource "aws_iam_role" "main" {
  name_prefix = "${local.prefix}-role-${var.client}"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF

}

resource "aws_iam_role_policy_attachment" "vpc" {
  role       = aws_iam_role.main.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}


resource "aws_iam_role_policy" "ssm" {
  name = "${local.prefix}-ssm-policy-${var.client}"
  role = aws_iam_role.main.id

  policy = <<-EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": [
          "ssm:Get*"
        ],
        "Effect": "Allow",
        "Resource": [
          "${local.ssm_prefix}/${var.client}/*", 
          "${local.ssm_prefix}/slack/*"
          ]
      }
    ]
  }
  EOF
}

resource "aws_iam_role_policy" "s3" {
  name = "${local.prefix}-s3-policy-${var.client}"
  role = aws_iam_role.main.id

  policy = <<-EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": [
          "s3:Get*",
          "s3:List*"
        ],
        "Effect": "Allow",
        "Resource": [
          "${var.script_bucket_arn}/*", 
          "${var.script_bucket_arn}"
          ]
      }
    ]
  }
  EOF
}
