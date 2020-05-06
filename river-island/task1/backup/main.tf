#Create S3 bucket
resource "aws_s3_bucket" "bucket" {
  bucket = "test-bucket"
  acl    = "private"

  tags = {
    Name        = "Test bucket"
  }
}

#Create IAM Profile
resource "aws_iam_instance_profile" "s3_access_profile" {
  name = "s3_access"
  role = "${aws_iam_role.s3_access_role.name}"
}

#Create IAM Policy
resource "aws_iam_role_policy" "s3_access_policy" {
  name = "s3_access_policy"
  role = "${aws_iam_role.s3_access_role.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "s3:*",
      "Resource": "*"
    }
  ]
}
EOF
}

#Create IAM Role
resource "aws_iam_role" "s3_access_role" {
  name = "s3_access_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
  {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
  },
      "Effect": "Allow",
      "Sid": ""
      }
    ]
}
EOF
}

#Creating SG to allow SSH Traffic
resource "aws_security_group" "SG-SSH" {
        name = "SG-SSH-HTTP"
        description = "SG to allow SSH Traffic"

        ingress {
                        from_port = 22
                        to_port = 22
                        protocol = "tcp"
                        cidr_blocks = ["0.0.0.0/0"]
        }

        egress {
                        from_port = 0
                        to_port = 0
                        protocol = "-1"
                        cidr_blocks = ["0.0.0.0/0"]
        }
}

#Create Instance
resource "aws_instance" "server" {
  ami           = "ami-087c2c50437d0b80d"
  instance_type = "t2.micro"
  iam_instance_profile = "${aws_iam_role.s3_access_role.name}"
  security_groups = ["${aws_security_group.SG-SSH.name}"]
  availability_zone = "us-west-2b"
  key_name = "test"
  tags = {
                        Name = "TestServer"
        }
}

#Create Route53 Entry
resource "aws_route53_record" "www" {
  zone_id = "Z06637632O564YAXULG3G"
  name    = "www"
  type    = "A"
  ttl     = "300"
  records = ["${aws_instance.server.public_ip}"]
}
