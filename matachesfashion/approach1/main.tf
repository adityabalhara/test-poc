provider "aws" {
  version = "= 2.51"
  region = "us-west-2"
}

provider "aws" {
  alias   = "child_accounts"
  version = "= 2.51"
  region = "us-west-2"
  assume_role {
    role_arn = "arn:aws:iam::${aws_organizations_account.child_accounts.id}:role/OrganizationAccountAccessRole"
  }
}

resource "aws_organizations_account" "child_accounts" {
  for_each = var.child_accounts
  name     = each.key
  email    = each.value
  role_name     = var.organizations_account_access_role_name
}

resource "aws_iam_user" "user" {
  name     = "user"
  path          = "${var.iam_path}"
  force_destroy = "${var.force_destroy}"
  provider = aws.child_accounts
}
