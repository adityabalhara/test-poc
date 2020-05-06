#! /bin/bash
cat >> aws_hosts
[Web] 
${aws_instance.webserver.public_ip} 

