output "Users" {
  value = {
    for key, value in aws_iam_access_key.user:
    key => { username: value.user, id: value.id, secret: value.secret }
  }
}
