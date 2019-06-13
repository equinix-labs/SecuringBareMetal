output "fortune cookie consumers" {
  value = ["${packet_device.fcc.*.access_public_ipv4}"]
}

output "fortune cookie servers" {
  value = ["${packet_device.fcs.*.access_public_ipv4}"]
}

output "consul server" {
  value = ["${packet_device.consul_server.*.access_public_ipv4}"]
}


output "vault server" {
  value = ["${packet_device.vault_server.*.access_public_ipv4}"]
}
