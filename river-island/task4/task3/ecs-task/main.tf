#Latest Revision
data "aws_ecs_task_definition" "ecs-task" {
  task_definition = aws_ecs_task_definition.ecs-task-taskdef.family
  depends_on      = [aws_ecs_task_definition.ecs-task-taskdef]
}

#Task definition template
data "template_file" "ecs-task" {
  template = file(var.TASK_DEF_TEMPLATE)

  vars = {
    APPLICATION_NAME    = var.APPLICATION_NAME
    APPLICATION_VERSION = var.APPLICATION_VERSION
    ECR_URL             = var.ECR_REPOSITORY_URL
    AWS_REGION          = var.AWS_REGION
    CPU_RESERVATION     = var.CPU_RESERVATION
    MEMORY_RESERVATION  = var.MEMORY_RESERVATION
  }
}

#Task definition
resource "aws_ecs_task_definition" "ecs-task-taskdef" {
  family                = var.APPLICATION_NAME
  container_definitions = data.template_file.ecs-task.rendered
  task_role_arn         = var.TASK_ROLE_ARN
}

#Scheduling
resource "aws_cloudwatch_event_rule" "schedule" {
  name                = "Run${replace(var.APPLICATION_NAME, "-", "")}"
  description         = "runs ecs task"
  schedule_expression = var.SCHEDULE
}
