resource "aws_iam_user" "user" {
  count = "${length(var.user_name) * length(var.env_name)}"
  name = "${element(local.product, count.index)[0]}-${element(local.product, count.index)[1]}"
#  name          = "${var.user_name[count.index]}-${var.env_name[count.index]}"
  path          = "${var.iam_path}"
  force_destroy = "${var.force_destroy}"
  tags = {
	Name = "${element(local.product, count.index)[0]}-${element(local.product, count.index)[1]}"
  }
}

resource "aws_iam_access_key" "user" {
  count = "${length(var.user_name) * length(var.env_name)}"
  user             = "${aws_iam_user.user[count.index].name}"
}

resource "aws_iam_user_policy" "user_policy" {
  count = "${length(var.user_name) * length(var.env_name)}"
  name_prefix = "${aws_iam_user.user[count.index].name}"
  user        = "${aws_iam_user.user[count.index].name}"
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "*",
            "Resource": "*"
        }
    ]
}
EOF
}
