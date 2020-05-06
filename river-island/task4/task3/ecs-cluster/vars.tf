variable "VPC_ID" {}
variable "CLUSTER_NAME" {}
variable "INSTANCE_TYPE" {}
variable "SSH_KEY_NAME" {}
variable "VPC_SUBNETS" {}
variable "LOG_GROUP" {}
variable "AWS_ACCOUNT_ID" {}
variable "AWS_REGION" {}
variable "ECS_MINSIZE" {
  default = 1
}
variable "ECS_MAXSIZE" {
  default = 1
}
variable "ECS_DESIRED_CAPACITY" {
  default = 1
}

