output "fortune_cookie_consumers" {
  value = metal_device.fcc.*.access_public_ipv4
}

output "fortune_cookie_servers" {
  value = metal_device.fcs.*.access_public_ipv4
}

output "consul_server" {
  value = metal_device.consul_server.*.access_public_ipv4
}


output "vault_server" {
  value = metal_device.vault_server.*.access_public_ipv4
}
