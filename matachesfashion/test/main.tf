provider "aws" {
  version = "= 2.18.0"
  region  = "us-west-2"
}

#locals {
  
#  product = "${setproduct(var.user_name, module.environment.aws_provider)}"
#}

module "environment" {
  source                                 = "./environment"
  account_alias                          = var.account_alias
  organizations_account_access_role_name = var.organizations_account_access_role_name
  child_accounts                         = var.child_accounts
}

module "user" {
  source = "./user"
#   for_each = module.environment.aws_provider
#   aws_provider   = "aws.${account_alias}"
#  count         = length(module.environment.aws_provider)
#  aws_provider  = "${module.environment.aws_provider}[count.index]"
  iam_path      = var.iam_path
#  force_destroy = var.force_destroy
#  user_name     = var.user_name
 # user_name = locals.product
    user_name = var.user_name
}

#output "aws_provider" {
#  value = "${aws_organizations_account.child_account[*].id}"
#   value = {
#    for key in module.environment.aws_provider :
#    key => { arn: value.arn , id: value.id }
#    key => { env_name: aws_organizations_account.child_account.name , id: value.id }
#}
#}
