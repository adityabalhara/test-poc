output "aws_provider" {
   value = "{aws_organizations_account.child_account[*].id}"
#    for key, value in aws_organizations_account.child_account:
#    key => { id: value.id }	
}

