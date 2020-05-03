terraform {
  required_version = "~>0.12"

  backend "s3" {
    bucket                  = "tfm-state-xxx282490297"
    region                  = "eu-west-1"
    key                     = "l320.tfstate"
    encrypt                 = "true"
    shared_credentials_file = "~/.aws/credentials"
    profile                 = "tfm-admin-shd"
  }
}



