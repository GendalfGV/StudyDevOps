# Configure the AWS Provider
variable "aws-instance-type" {
  default = "t2.micro"
  description = "EC2 acces key pair"
}
variable "aws-ami" {
    default="ami-0dd9f0e7df0f0a138"
    description="EC2 ami"
}

provider "aws" {
}

resource "aws_instance" "developer" {
    ami = "${var.aws-ami}"
    instance_type = "${var.aws-instance-type}"
    vpc_security_group_ids = aws_security_group.DevopsSG.id
    user_data=<<EOF
#!/bin/bash
apt update
apt install default-jdk -y
apt install git -y
apt install maven -y
apt install awscli - y
git clone https://github.com/boxfuse/boxfuse-sample-java-war-hello.git /home/user/boxfuse 
cd /home/user/boxfuse
mvn package
aws s3 sync /home/user/boxfuse/target/hello-1.0.war DevopsBucket21122020
    EOF
}

resource "aws_instance" "production" {
    ami = "${var.aws-ami}"
    instance_type = "${var.aws-instance-type}"
    vpc_security_group_ids = aws_security_group.DevopsSG.id
    user_data=<<EOF
#!/bin/bash
apt update
apt install default-jdk -y
apt install tomcat9 -y
apt install awscli - y
aws s3 sync DevopsBucket21122020/hello-1.0.war  /var/lib/tomcat9/webapps/ 
    EOF
}

resource "aws_security_group" "DevopsSG" {
    name = "Devops Security Group"
    ingress {
        from_port = 8080
        to_port = 8080
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

resource "aws_s3_bucket" "DevopsBucket21122020" {
  bucket = "DevopsBucket21122020"
  acl    = "private"

  tags = {
    Name        = "DevopsBucket21122020"
    Environment = "Dev"
  }
}
