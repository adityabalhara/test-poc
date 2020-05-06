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

resource "aws_instance" "webserver" {
  ami           = "${var.ami_id}"
  instance_type = "${var.web_instance_type}"
  security_groups = ["${aws_security_group.SG-SSH-HTTP.name}"]
  availability_zone = "${var.availability_zone}"
  key_name = "${var.key_name}"
  tags = {
			Name = "WebServer"
	}
  
  provisioner "local-exec" {
    command = <<EOD
	cat <<EOF > aws_hosts 
	[Web] 
	${aws_instance.webserver.public_ip} 
	[Web:vars] 
        web_ip=${aws_instance.webserver.public_ip}
        EOD
      }

  provisioner "local-exec" {
		command = "aws ec2 wait instance-status-ok --instance-ids ${aws_instance.webserver.id} && ansible-playbook -i aws_hosts --private-key=test.pem apache.yml"
}
}
