data "aws_caller_identity" "current" {}

data "terraform_remote_state" "vpc" {
	backend = "local" 

	config = {
		path = "./vpc/terraform.tfstate"
	}
}

module "my-ecs" {
  source         = "./ecs-cluster"
  VPC_ID         = "${data.terraform_remote_state.vpc.outputs.vpc_id}"
  CLUSTER_NAME   = "my-ecs"
  INSTANCE_TYPE  = "t2.small"
  SSH_KEY_NAME   = "test"
#  VPC_SUBNETS    = "${join(",", module.vpc.public_subnets)}"
  VPC_SUBNETS    = "${join(",", data.terraform_remote_state.vpc.outputs.public_subnets)}"
  LOG_GROUP      = "my-log-group"
  AWS_ACCOUNT_ID = "${data.aws_caller_identity.current.account_id}"
  AWS_REGION     = "${var.AWS_REGION}"
}

module "my-service" {
  source              = "./ecs-service"
  VPC_ID              = "${data.terraform_remote_state.vpc.outputs.vpc_id}"
#  VPC_ID              = "${module.vpc.vpc_id}"
  APPLICATION_NAME    = "my-service"
  APPLICATION_PORT    = "80"
  APPLICATION_VERSION = "latest"
  ECR_URL             = "nginx"
  CLUSTER_ARN         = "${module.my-ecs.cluster_arn}"
  SERVICE_ROLE_ARN    = "${module.my-ecs.service_role_arn}"
  AWS_REGION          = "${var.AWS_REGION}"
  HEALTHCHECK_MATCHER = "200"
  CPU_RESERVATION     = "256"
  MEMORY_RESERVATION  = "128"
  LOG_GROUP           = "my-log-group"
  DESIRED_COUNT       = 2
  ALB_ARN             = "${module.my-alb.alb_arn}"
}

module "my-alb" {
  source             = "./alb"
  VPC_ID              = "${data.terraform_remote_state.vpc.outputs.vpc_id}"
#  VPC_ID             = "${module.vpc.vpc_id}"
  ALB_NAME           = "my-alb"
  VPC_SUBNETS        = "${join(",", data.terraform_remote_state.vpc.outputs.public_subnets)}"
  DEFAULT_TARGET_ARN = "${module.my-service.target_group_arn}"
  PRIORITY           = 100
  INTERNAL           = false
  ECS_SG             = "${module.my-ecs.cluster_sg}"
  CONDITION_FIELD    = "host-header"
  CONDITION_VALUES   = ["subdomain.my-ecs.com"]
}
