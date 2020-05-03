provider "aws" {
  version                 = "~>2.2"
  region                  = var.region
  allowed_account_ids     = [var.account_id]
  shared_credentials_file = "~/.aws/credentials"
  profile                 = "tfm-admin-shd"
  assume_role {
    role_arn = "arn:aws:iam::${var.account_id}:role/${var.tfm_adm_iam_role}"
  }
}
