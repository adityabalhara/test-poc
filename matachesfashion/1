resource "aws_iam_user" "user" {
  name          = "${var.user_name}"
  path          = "${var.iam_path}"
  force_destroy = "${var.force_destroy}"
}

resource "aws_iam_access_key" "user" {
  user             = "${aws_iam_user.user.name}"
}

resource "aws_iam_user_policy" "user_policy" {
  name_prefix = "${var.user_name}"
  user        = "${aws_iam_user.user.name}"
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
