variable "elb-names" {
  type = list
  default = ["ganesh-Kub-Master1", "ganesh-Kub-node1","ganesh-Kub-node2"]
}

variable "list" {
  type = list
  default = ["t2.medium","t2.medium","t2.medium"]
}


resource "aws_instance" "team42" {
ami = "ami-0522ab6e1ddcc7055"
key_name = "team4india"
count= 3
   instance_type = var.list[count.index]
tags= {
Name= var.elb-names[count.index]
}

  provisioner "local-exec" {
    command = <<EOT
      echo "[master]" > inventory
      echo "${aws_instance.team42[0].private_ip} ansible_user=ec2-user ansible_ssh_private_key_file=~/.ssh/ganesh-import.pem" >> inventory
      echo "[nodes]" >> inventory
      echo "${aws_instance.team42[1].private_ip} ansible_user=ec2-user ansible_ssh_private_key_file=~/.ssh/ganesh-import.pem" >> inventory
      echo "${aws_instance.team42[2].private_ip} ansible_user=ec2-user ansible_ssh_private_key_file=~/.ssh/ganesh-import.pem" >> inventory
    EOT
  }
}
