variable "elb-names" {
  type = list
  default = ["ganesh-Kub-Master", "ganesh-Kub-node1","ganesh-Kub-node2"]
}

variable "list" {
  type = list
  default = ["t2.large","t2.medium","t2.medium"]
}


resource "aws_instance" "team42" {
ami = "ami-0e86e20dae9224db8"
key_name = "ganesh-Virginia"
count= 3
   instance_type = var.list[count.index]
tags= {
Name= var.elb-names[count.index]
}

  provisioner "local-exec" {
    command = <<EOT
      if [ ${count.index} -eq 0 ]; then
        echo "[master]" >> hosts.ini
        echo "${self.private_ip} ansible_user=ubuntu ansible_ssh_private_key_file=~/.ssh/id_rsa" >> hosts.ini
      fi
      if [ ${count.index} -eq 1 ]; then
        echo "[nodes]" >> hosts.ini
        echo "${self.private_ip} ansible_user=ubuntu ansible_ssh_private_key_file=~/.ssh/id_rsa" >> hosts.ini
      fi
      if [ ${count.index} -eq 2 ]; then
        echo "${self.private_ip} ansible_user=ubuntu ansible_ssh_private_key_file=~/.ssh/id_rsa" >> hosts.ini
      fi
    EOT
    
  }
}
