variable "iam_path" {
  default     = "/"
  description = "Path of where you want to create the IAM resource"
}
variable "force_destroy" {
  description = "When destroying this user, destroy even if it has non-Terraform-managed IAM access keys"
  default     = "false"
}
variable "organizations_account_access_role_name" {
  description = "The name to use for the IAM role that will be created in child accounts. Users in the root account will be able to assume this role to get admin access to those child accounts."
  type        = string
  default     = "OrganizationAccountAccessRole"
}
variable "child_accounts" {
  type        = map(string)
  default     = { devtest = "aditya.balhara91@gmail.com"}
}
