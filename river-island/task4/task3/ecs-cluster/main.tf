#Creating SG to allow ECS CLUSTER Traffic
resource "aws_security_group" "cluster" {
        name = "ECS-CLUSTER-SG"
        description = "SG to allow ECS Traffic"
	vpc_id      = var.VPC_ID
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

resource "aws_security_group_rule" "cluster-allow-alb" {
  security_group_id        = aws_security_group.cluster.id
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  source_security_group_id = aws_security_group.cluster.id
}

#IAM Role for EC2
resource "aws_iam_role" "cluster-ec2-role" {
name = "ecs-${var.CLUSTER_NAME}-ec2-role"

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

resource "aws_iam_instance_profile" "cluster-ec2-role" {
name = "ecs-${var.CLUSTER_NAME}-ec2-role"
role = aws_iam_role.cluster-ec2-role.name
}

resource "aws_iam_role_policy" "cluster-ec2-role" {
name = "cluster-ec2-role-policy"
role = aws_iam_role.cluster-ec2-role.id

policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
              "ecs:CreateCluster",
              "ecs:DeregisterContainerInstance",
              "ecs:DiscoverPollEndpoint",
              "ecs:Poll",
              "ecs:RegisterContainerInstance",
              "ecs:StartTelemetrySession",
              "ecs:Submit*",
              "ecs:StartTask",
              "ecr:GetAuthorizationToken",
              "ecr:BatchCheckLayerAvailability",
              "ecr:GetDownloadUrlForLayer",
              "ecr:BatchGetImage",
              "logs:CreateLogStream",
              "logs:PutLogEvents"
            ],
            "Resource": "*"
        },
        {
          "Effect": "Allow",
          "Action": [
              "logs:*"
          ],
          "Resource": [
              "arn:aws:logs:${var.AWS_REGION}:${var.AWS_ACCOUNT_ID}:log-group:${var.LOG_GROUP}:*"
          ]
        }
    ]
}
EOF

}

#IAM Role for Cluster Service
resource "aws_iam_role" "cluster-service-role" {
  name = "ecs-service-role-${var.CLUSTER_NAME}"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ecs.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

}

resource "aws_iam_role_policy" "cluster-service-role" {
  name = "${var.CLUSTER_NAME}-policy"
  role = aws_iam_role.cluster-service-role.name

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ec2:AuthorizeSecurityGroupIngress",
                "ec2:Describe*",
                "elasticloadbalancing:DeregisterInstancesFromLoadBalancer",
                "elasticloadbalancing:DeregisterTargets",
                "elasticloadbalancing:Describe*",
                "elasticloadbalancing:RegisterInstancesWithLoadBalancer",
                "elasticloadbalancing:RegisterTargets"
            ],
            "Resource": "*"
        }
    ]
}
EOF

}

#ECS AMI
data "aws_ami" "ecs" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-ecs-hvm*-x86_64-ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
 owners = ["amazon"]
}

#ECS Cluster
resource "aws_ecs_cluster" "cluster" {
  name = var.CLUSTER_NAME
}

#Launch Config
resource "aws_launch_configuration" "cluster" {
  name_prefix          = "ecs-${var.CLUSTER_NAME}-launchconfig"
  image_id             = data.aws_ami.ecs.id
  instance_type        = var.INSTANCE_TYPE
  key_name             = var.SSH_KEY_NAME
  iam_instance_profile = aws_iam_instance_profile.cluster-ec2-role.id
  security_groups      = [aws_security_group.cluster.id]
  lifecycle {
    create_before_destroy = true
  }
}

#Auto-Scaling Group
resource "aws_autoscaling_group" "cluster" {
  name                 = "ecs-${var.CLUSTER_NAME}-autoscaling"
  vpc_zone_identifier  = split(",", var.VPC_SUBNETS)
  launch_configuration = aws_launch_configuration.cluster.name
  min_size             = var.ECS_MINSIZE
  max_size             = var.ECS_MAXSIZE
  desired_capacity     = var.ECS_DESIRED_CAPACITY

  tag {
    key                 = "Name"
    value               = "${var.CLUSTER_NAME}-ecs"
    propagate_at_launch = true
  }
}

