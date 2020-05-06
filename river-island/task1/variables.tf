variable "AWS_ACCESS_KEY"  {}
variable "AWS_SECRET_KEY"  {}
variable "AWS_REGION"  {
                default = "us-west-2"
}
variable "bucket_name" {
	default = "rivertestdemo"
}
variable "ami_id" {
	default = "ami-087c2c50437d0b80d"
}
variable "instance_type" {
	default = "t2.micro"
}
variable "availability_zone" {
	default = "us-west-2b"
}
variable "key_name" {
	default = "test"
}
variable "instance_name" {
	default = "TestServer"
}
variable "zone_id" {
	default = "Z02924553B1BKFKVFU09F"
}
variable "record_name" {
	default = "www.test"
}
variable "record_type" {
	default = "A"
}
variable "record_ttl" {
	default = "300"
}
