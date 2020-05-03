
resource "aws_s3_bucket" "scripts" {
  bucket = "${local.script_bucket_prefix}-${var.client}-${var.account_id}"
  acl    = "bucket-owner-full-control"

  versioning {
    enabled = true
  }

  lifecycle_rule {
    enabled = true

    expiration {
      days = var.expiration
    }
  }

  tags = merge(
    var.default_tags,
    map(
      "Name", "${local.script_bucket_prefix}-${var.client}-${var.account_id}",
      "Workspace", terraform.workspace
    )
  )
}

resource "aws_s3_account_public_access_block" "scripts" {
  block_public_acls   = true
  block_public_policy = true
}

