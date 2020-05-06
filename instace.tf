#Creating SG to allow SSH and HTTP Traffic

resource "aws_security_group" "SG-SSH-HTTP" {
	name = "SG-SSH-HTTP"
	description = "SG to allow SSH/HTTP Traffic"
	
	ingress { 
			from_port = 22
			to_port = 22
			protocol = "tcp"
			cidr_blocks = ["0.0.0.0/0"]
	}
	
	ingress { 
			from_port = 80
			to_port = 80
			protocol = "tcp"
			cidr_blocks = ["0.0.0.0/0"]
	}
	
	egress { 
			from_port = 0
			to_port = 0
			protocol = "-1"
			cidr_blocks = ["0.0.0.0/0"]
	}
}

resource "aws_instance" "instance" {
  ami           = "${lookup(var.AMIS, var.AWS_REGION)}"
  instance_type = "t2.micro"
  security_groups = ["${aws_security_group.SG-SSH-HTTP.name}"]
  availability_zone = "us-west-2b"
  key_name = "test"
  tags = {
			Name = "Apache_Server"
	}
}

