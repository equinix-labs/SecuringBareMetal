output "web servers" {
  value = ["${packet_device.web.*.access_public_ipv4}"]
}

output "fortune cookie servers" {
  value = ["${packet_device.fcs.*.access_public_ipv4}"]
}

output "consul vault_server" {
  value = ["${packet_device.consul_vault_server.access_public_ipv4}"]
}
