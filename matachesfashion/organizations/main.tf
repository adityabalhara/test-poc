
resource "aws_organizations_organization" "org" {
  feature_set                   = "ALL"
  aws_service_access_principals = ["cloudtrail.amazonaws.com"]
}

resource "aws_organizations_account" "child_accounts" {
  for_each = var.child_accounts
  name     = each.key
  email    = each.value
  role_name     = var.organizations_account_access_role_name
}
