#output "UserName" {
#  value = "${aws_iam_user.user[*].name}"
#}
#output "Secret_key" {
#  value = ["${aws_iam_user.user[*].name}",
#  "${aws_iam_access_key.user[*].secret}",
#  "${aws_iam_access_key.user[*].id}"]
#}
#output "Access_Key" {
#  value = "${aws_iam_access_key.user[*].id}"
#}
output "Users" {
  value = {
    for key, value in aws_iam_access_key.user:
    key => { username: value.user, id: value.id, secret: value.secret }
  }
}

