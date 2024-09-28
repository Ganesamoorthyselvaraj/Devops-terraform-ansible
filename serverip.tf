resource "aws_network_interface" "example" {
  count          = 3
  subnet_id      = "subnet-ganesh"
  private_ips    = ["172.31.120.11", "172.31.120.12","172.31.120.13"]
  security_groups = ["gaqnesh_allow_ssh"]
}
