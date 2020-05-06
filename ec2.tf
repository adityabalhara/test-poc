provider "aws" {
  access_key = "AKIAJINCGMHSH3LHS4VA"
  secret_key = "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"
  region     = "us-west-2"
}

resource "aws_instance" "test" {
  ami           = "ami-087c2c50437d0b80d"
  instance_type = "t2.micro"
}
