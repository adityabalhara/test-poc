provider "aws" {
  version = "= 2.18.0"
  region = "us-west-2"
  access_key = "AKIAJOP2XXRWPN2OAJMA"
  secret_key = "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"
}

provider "aws" {
  alias   = "secondary"
  region = "us-west-2"
  access_key = "AKIAJOP2XXRWPN2OAJMA"
  secret_key = "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"
  version = "= 2.18.0"
  assume_role {
    role_arn = "arn:aws:iam::${aws_organizations_account.secondary.id}:role/OrganizationAccountAccessRole"
  }
}

resource "aws_organizations_account" "secondary" {
  name  = "devtest"
  email = "ta312408@gmail.com"
}

resource "aws_iam_user" "user1" {
  name     = "user"
}

resource "aws_iam_user" "user" {
  name     = "user"
  provider = aws.secondary
}
