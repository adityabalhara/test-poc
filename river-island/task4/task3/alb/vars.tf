variable "ALB_PROTOCOL" {
  default = "HTTP"
}

variable "PRIORITY" {
}

variable "CONDITION_FIELD" {
}

variable "CONDITION_VALUES" {
  type = list(string)
}
variable "ALB_NAME" {
}

variable "INTERNAL" {
}

variable "VPC_ID" {
}

variable "VPC_SUBNETS" {
}

variable "DEFAULT_TARGET_ARN" {
}

variable "ECS_SG" {
}
