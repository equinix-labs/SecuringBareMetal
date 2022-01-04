output "fortune cookie consumers" {
  value = ["${metal_device.fcc.*.access_public_ipv4}"]
}

output "fortune cookie servers" {
  value = ["${metal_device.fcs.*.access_public_ipv4}"]
}

output "consul server" {
  value = ["${metal_device.consul_server.*.access_public_ipv4}"]
}


output "vault server" {
  value = ["${metal_device.vault_server.*.access_public_ipv4}"]
}
