variable "child_accounts" {
  type = map(string)
  default = {
    non-prod = "ta3124071@gmail.com"
    prod     = "ta3124081@gmail.com"
  }
}

variable "user_name" {
  type=list
}

variable "organizations_account_access_role_name" {
  default = "OrganizationAccountAccessRole"
}

variable "iam_path" {
  default = "/"
}

variable "force_destroy" {
  default = "true"
}

variable "account_alias" {
  default = ["non-prod", "prod"]
}

