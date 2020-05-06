inputs = {
  # Fill in your region you want to use (only used for API calls) and the ID of your root AWS account
  aws_region     = "us-west-2"
  aws_account_id = "205626125398"

  # Specify the child accounts you want
  child_accounts = {
    dev             = "account-root+dev@abc.com"
    qa		    = "account-root+qa@abc.com"
    uat             = "account-root+uat@abc.com"
    test            = "account-root+test@abc.com"
    prod            = "account-root+prod@abc.com"
  }
}

include {
  path = find_in_parent_folders()
}
