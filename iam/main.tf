resource "aws_iam_user" "main" {
  name = local.username
}

resource "aws_iam_user_policy" "main" {
  name = "${local.username}-s3-policy"
  user = aws_iam_user.main.name

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "s3:ListAllMyBuckets",
            "Resource": "arn:aws:s3:::*",
            "Effect": "Allow"
        },
        {
            "Action": "s3:*",
            "Resource": [
                "${var.script_bucket_arn}",
                "${var.script_bucket_arn}/*"
            ],
            "Effect": "Allow"
        },
        {
            "Action": "ssm:*",
            "Effect": "Allow",
            "Resource": [
              "${local.ssm_prefix}/${var.client}/issues/*"
              ]
        }
    ]
}
EOF
}
