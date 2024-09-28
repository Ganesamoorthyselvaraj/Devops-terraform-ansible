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
  filter {
    name   = "group-name"
    values = ["Ganesh-wizard-380"]
  }

variable "elb-names" {
  type = list
  default = ["ganesh-Kub-Master", "ganesh-Kub-node1","ganesh-Kub-node2"]
}

variable "list" {
  type = list
  default = ["t2.medium","t2.medium","t2.medium"]
}
resource "aws_instance" "myawsserver" {
count =3  
ami = "ami-0e54eba7c51c234f6"
  vpc_security_group_ids = [data.aws_security_group.existing_sg.id]
  instance_type = var.list[count.index]
  key_name = "ganesh-import"
network_interface {
    network_interface_id = aws_network_interface.example[count.index].id
    device_index         = 0
}
  tags = {
    Name = var.elb-names[count.index]
    env = "Production"
    owner = "Ganesh"

  }
  provisioner "local-exec" {
    command = "echo The servers IP address is ${self.public_ip} && echo ${self.public_ip} > /tmp/inv"
  }
}

