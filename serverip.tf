resource "aws_network_interface" "example" {
  count          = 3
  subnet_id      = "subnet-0359cfab31b2e208d"
  private_ips    = ["172.31.120.220", "172.31.120.221","172.31.120.222"]
  security_groups = [aws_security_group.allow_ssh.id]
}
