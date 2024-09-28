terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.64.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_security_group" "allow_ssh" {
  name        = "Ganesh-wizard-380"
  description = "Allow SSH and HTTP inbound traffic"
  vpc_id      = "vpc-00dae5f3df962676d"

  ingress {
    description = "SSH into VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP into VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Outbound Allowed"
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_network_interface" "example" {
  count           = 3
  subnet_id       = "subnet-0359cfab31b2e208d"
    security_groups = [aws_security_group.allow_ssh.id]
}

resource "aws_instance" "myawsserver" {
  count          = 3
  ami            = "ami-0e54eba7c51c234f6"
  instance_type  = "t2.medium"
  key_name       = "ganesh-import"

  network_interface {
    network_interface_id = aws_network_interface.example[count.index].id
    device_index         = 0
  }

  tags = {
    Name  = "ganesh-Kub-${count.index + 1}"
    env   = "Production"
    owner = "Ganesh"
  }

  provisioner "local-exec" {
    command = "echo The server's IP address is ${self.public_ip} && echo ${self.public_ip} > /tmp/inv"
  }
}
