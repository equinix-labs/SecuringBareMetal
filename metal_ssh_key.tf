# this public key is injected into all new bare metal hosts that are provisioned
resource "metal_ssh_key" "host_key" {
  name       = "host_key"
  public_key = file(var.public_key_filename)
}
