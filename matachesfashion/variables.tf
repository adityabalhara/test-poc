variable "AWS_ACCESS_KEY"  {}
variable "AWS_SECRET_KEY"  {}
variable "AWS_REGION"  {
                default = "us-west-2"
}
variable "iam_path" {
  default     = "/"
  description = "Path of where you want to create the IAM resource"
}
variable "force_destroy" {
  description = "When destroying this user, destroy even if it has non-Terraform-managed IAM access keys"
  default     = "false"
}
variable "user_name" {
  type = "list"
  default = ["nevsa","cordelia","kriste","darleen","wynnie","vonnie","emelita","maurita","devinne","breena"]

}
variable "env_name" {
  type = "list"
#  default = "dev"
  default = ["dev","qa","uat","test","prod"]
}

locals {
  product = "${setproduct(var.user_name, var.env_name)}"
}
