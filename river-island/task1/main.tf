#Create S3 bucket
resource "aws_s3_bucket" "bucket" {
  bucket = var.bucket_name
  acl    = "private"

  tags = {
    Name        = "${var.bucket_name}"
  }
}

#Create IAM Profile
resource "aws_iam_instance_profile" "s3_access_profile" {
  name = "s3_access"
  role = aws_iam_role.s3_access_role.name
}

#Create IAM Policy
resource "aws_iam_role_policy" "s3_access_policy" {
  name = "s3_access_policy"
  role = aws_iam_role.s3_access_role.id

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

#Creating SG to allow SSH and HTTP Traffic
resource "aws_security_group" "SG-SSH-HTTP" {
        name = "SG-SSH-HTTP-demo"
        description = "SG to allow SSH/HTTP Traffic"

        dynamic "ingress" {
		for_each = [22, 80]
		content {
			from_port = ingress.value
			to_port = ingress.value
			protocol = "tcp"
			cidr_blocks = ["0.0.0.0/0"]
		}
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
  count		= "5"
  ami           = var.ami_id
  instance_type = var.instance_type
  iam_instance_profile = aws_iam_instance_profile.s3_access_profile.name
  security_groups = [aws_security_group.SG-SSH-HTTP.name]
  availability_zone = var.availability_zone
  key_name = var.key_name
  tags = {
                        Name = "${var.instance_name}-${count.index +1}"
			Group = "Server"
        }
}

data "aws_instances" "instances" {
	filter {
	  name = "tag:Group"
	  values = ["Server"]
  }
  instance_state_names = ["running", "pending"]
  depends_on = [
    aws_instance.server
  ]
}

#Create Route53 Entry
resource "aws_route53_record" "www" {
  count = length(aws_instance.server)
  zone_id = "${var.zone_id}"
  name    = "${var.record_name}${count.index +1}"
  type    = var.record_type
  ttl     = var.record_ttl
  records = ["${data.aws_instances.instances.public_ips[count.index]}"]
}
