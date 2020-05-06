provider "aws" {
  region = "us-west-2"
  version = "= 2.18.0"
}
provider "aws" {
  region = "us-west-2"
  alias   = "prod"
  version = "= 2.18.0"
#  assume_role {
#    role_arn = "arn:aws:iam::${aws_organizations_account.child_account.id}:role/${var.organizations_account_access_role_name}"
  }

resource "aws_iam_user" "user" {
  count = "${length(var.user_name)}"
 # name  = "${element(var.user_name, count.index)[0]}-${element(var.user_name, count.index)[1]}"
   name= var.user_name[count.index]
#  name		= "${var.user_name[count.index]}"
  path          = "${var.iam_path}"
#  force_destroy = "${var.force_destroy}"
#  provider = "aws.prod"
# provider      = "${element(var.user_name, count.index)[1]}"
}

resource "aws_iam_access_key" "user" {
  count = "${length(var.user_name)}"
  #user  = "${element(var.user_name, count.index)[0]}-${element(var.user_name, count.index)[1]}"
user= var.user_name[count.index]
}

