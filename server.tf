variable "elb-names" {
  type    = list(string)
  default = ["ganesh-Kub-Master", "ganesh-Kub-node1","ganesh-Kub-node2"]
}

variable "list" {
  type    = list(string)
  default = ["t2.large", "t2.medium", "t2.medium"]
}

resource "aws_instance" "team42" {
  count         = 3
  ami           = "ami-0e86e20dae9224db8"
  instance_type = var.list[count.index]
  key_name      = "ganesh-import"

  tags = {
    Name = var.elb-names[count.index]
  }
  root_block_device {
    volume_size = 20
  }

  provisioner "local-exec" {
   command = <<EOT
      if  [ ${count.index} -eq 2 ]; then
        echo "[workers]" > hosts.ini
echo "${self.private_ip} ansible_user=ubuntu ansible_ssh_private_key_file=~/.ssh/id_rsa" >> hosts.ini
elif [ ${count.index} -eq 1 ]; then
        echo "${self.private_ip} ansible_user=ubuntu ansible_ssh_private_key_file=~/.ssh/id_rsa" >> hosts.ini
else
echo "[master]" >> hosts.ini
        echo "${self.private_ip} ansible_user=ubuntu ansible_ssh_private_key_file=~/.ssh/id_rsa" >> hosts.ini
      fi
    EOT
  }
}
