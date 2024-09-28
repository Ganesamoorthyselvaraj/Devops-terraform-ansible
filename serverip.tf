resource "aws_network_interface" "example" {
  count          = 3
  subnet_id      = "subnet-0359cfab31b2e208d"
  private_ips    = ["172.31.120.11", "172.31.120.12","172.31.120.13"]
  
}
