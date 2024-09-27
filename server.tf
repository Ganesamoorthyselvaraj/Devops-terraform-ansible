terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.64.0"
    }
  }
}

provider "aws" {
region = "us-east-1"
}

data "aws_security_group" "existing_sg" {
  name = "gaqnesh_allow_ssh"
}
resource "aws_instance" "myawsserver" {
  ami = "ami-0e54eba7c51c234f6"
  vpc_security_group_ids = [data.aws_security_group.existing_sg.id]
  instance_type = "t2.micro"
  key_name = "ganesh-import"

  tags = {
    Name = "ganesh-DevOps-batch-server"
    env = "Production"
    owner = "Ganesh"
  }
  provisioner "local-exec" {
    command = "echo The servers IP address is ${self.public_ip} && echo ${self.public_ip} > /tmp/inv"
  }
}

