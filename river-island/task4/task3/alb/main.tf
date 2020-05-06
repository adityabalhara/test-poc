#ALB Listener Rule
resource "aws_lb_listener_rule" "alb_rule" {
  listener_arn = aws_lb_listener.alb-http.arn
  priority     = var.PRIORITY

  action {
    type             = "forward"
    target_group_arn = var.DEFAULT_TARGET_ARN
  }

  condition {
    field  = var.CONDITION_FIELD
    values = var.CONDITION_VALUES
  }
}

# ALB Definition
resource "aws_lb" "alb" {
  name            = var.ALB_NAME
  internal        = var.INTERNAL
  load_balancer_type = "application"
  security_groups = [var.ECS_SG]
  subnets         = split(",", var.VPC_SUBNETS)

  enable_deletion_protection = false
}

# ALB Listener
resource "aws_lb_listener" "alb-http" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = var.DEFAULT_TARGET_ARN
    type             = "forward"
  }
}
