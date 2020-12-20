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
    user_data=<<EOF
#!/bin/bash
apt update
apt install default-jdk -y
apt install git -y
apt install maven -y
git clone https://github.com/boxfuse/boxfuse-sample-java-war-hello.git /home/user/boxfuse 
cd /home/user/boxfuse
mvn package

    EOF
}

resource "aws_instance" "production" {
    ami = "${var.aws-ami}"
    instance_type = "${var.aws-instance-type}"
    user_data=<<EOF
#!/bin/bash
apt update
apt install default-jdk -y
apt install tomcat9 -y
cp s3 to /var/lib/tomcat9/webapps/
git clone https://github.com/boxfuse/boxfuse-sample-java-war-hello.git /home/user/boxfuse 
cd /home/user/boxfuse
mvn package
    EOF
}
