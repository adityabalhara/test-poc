provider "aws" {
   region = "us-west-2"
#  alias   = "${var.account_alias}"
  version = "= 2.18.0"
#  assume_role {
#    role_arn = "arn:aws:iam::${aws_organizations_account.child_account.id}:role/${var.organizations_account_access_role_name}"
  }
#}
resource "aws_organizations_account" "child_account" {
 for_each = var.child_accounts
  name     = each.key
  email    = each.value
  role_name     = var.organizations_account_access_role_name
}


