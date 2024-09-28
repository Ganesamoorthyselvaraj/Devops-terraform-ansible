resource "aws_network_interface" "example" {
  count          = 3
  subnet_id      = "subnet-abc123"
  private_ips    = ["10.0.1.50", "10.0.1.51","10.0.1.51"]
  security_groups = ["gaqnesh_allow_ssh"]
}
