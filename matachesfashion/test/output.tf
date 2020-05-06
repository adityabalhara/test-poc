#output "Users" {
#  value = {
#    for key, value in module.user.aws_iam_access_key.user:
#    key => { username: value.user, id: value.id, secret: value.secret }
#  }
#}
#output "aws_provider" {
#  value = "${module.environment.aws_organizations_account.child_account[*].id}"
#   value = {
#    for key, value in module.environment.aws_organizations_account.child_account:
#    key => { env_name: aws_organizations_account.child_account.name , id: value.id }
#}
#}
#output "account_name" {
#  value = "${module.environment.aws_organizations_account.child_account[*].arn}"
#}
