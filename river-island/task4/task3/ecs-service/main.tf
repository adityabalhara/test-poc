#ALB Target Group
resource "aws_alb_target_group" "ecs-service" {
  name = "${var.APPLICATION_NAME}-${substr(
    md5(
      format(
        "%s%s%s",
        var.APPLICATION_PORT,
        var.DEREGISTRATION_DELAY,
        var.HEALTHCHECK_MATCHER,
      ),
    ),
    0,
    12,
  )}"
  port                 = var.APPLICATION_PORT
  protocol             = "HTTP"
  vpc_id               = var.VPC_ID
  deregistration_delay = var.DEREGISTRATION_DELAY

  health_check {
    healthy_threshold   = 3
    unhealthy_threshold = 3
    protocol            = "HTTP"
    path                = "/"
    interval            = 60
    matcher             = var.HEALTHCHECK_MATCHER
  }
}

#Get Latest Revision
data "aws_ecs_task_definition" "ecs-service" {
  task_definition = aws_ecs_task_definition.ecs-service-taskdef.family
  depends_on      = [aws_ecs_task_definition.ecs-service-taskdef]
}

#Task Definition Template
data "template_file" "ecs-service" {
  template = file("${path.module}/ecs-service.json")

  vars = {
    APPLICATION_NAME    = var.APPLICATION_NAME
    APPLICATION_PORT    = var.APPLICATION_PORT
    APPLICATION_VERSION = var.APPLICATION_VERSION
    ECR_URL             = var.ECR_URL
    AWS_REGION          = var.AWS_REGION
    CPU_RESERVATION     = var.CPU_RESERVATION
    MEMORY_RESERVATION  = var.MEMORY_RESERVATION
    LOG_GROUP           = var.LOG_GROUP
  }
}

#Task Definition
resource "aws_ecs_task_definition" "ecs-service-taskdef" {
  family                = var.APPLICATION_NAME
  container_definitions = data.template_file.ecs-service.rendered
  task_role_arn         = var.TASK_ROLE_ARN
}

#ECS Service
resource "aws_ecs_service" "ecs-service" {
  name    = var.APPLICATION_NAME
  cluster = var.CLUSTER_ARN
  task_definition = "${aws_ecs_task_definition.ecs-service-taskdef.family}:${max(
    aws_ecs_task_definition.ecs-service-taskdef.revision,
    data.aws_ecs_task_definition.ecs-service.revision,
  )}"
  iam_role                           = var.SERVICE_ROLE_ARN
  desired_count                      = var.DESIRED_COUNT
  deployment_minimum_healthy_percent = var.DEPLOYMENT_MINIMUM_HEALTHY_PERCENT
  deployment_maximum_percent         = var.DEPLOYMENT_MAXIMUM_PERCENT

  load_balancer {
    target_group_arn = aws_alb_target_group.ecs-service.id
    container_name   = var.APPLICATION_NAME
    container_port   = var.APPLICATION_PORT
  }

  depends_on = [null_resource.alb_exists]
}

resource "null_resource" "alb_exists" {
  triggers = {
    alb_name = var.ALB_ARN
  }
}
