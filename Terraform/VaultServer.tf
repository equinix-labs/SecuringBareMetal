resource "metal_device" "vault_server" {

  depends_on = [metal_ssh_key.host_key]

  project_id       = var.metal_project_id
  metro            = var.metro
  plan             = var.plan
  operating_system = var.operating_system
  hostname         = format("vault%02d", count.index)

  # should be an odd number
  # > 1 will require update to the consul config file bootstrap values
  count = var.vault_count

  billing_cycle = "hourly"

  connection {
    user        = "root"
    host        = self.access_public_ipv4
    private_key = file(var.private_key_filename)
  }

  provisioner "remote-exec" {
    inline = [
      "ssh-keygen -A",
      "apt-get update -y >> apt.out",
      "apt-get install fortune tcpflow dnsutils zip asciinema -y >> apt.out",
      "mkdir -p /etc/vault.d",
    ]
  }

  provisioner "file" {
    source      = "${path.module}/vault-server-config.json"
    destination = "/etc/vault.d/vault-server-config.json"
  }

  provisioner "file" {
    source      = "${path.module}/StartVaultServer.sh"
    destination = "/usr/local/bin/StartVaultServer.sh"
  }

  provisioner "file" {
    source      = "${path.module}/vault_install.sh"
    destination = "vault_install.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "bash vault_install.sh > vault_install.out",
      "chmod 755 /usr/local/bin/StartVaultServer.sh",
      "screen -dmS vault /usr/local/bin/StartVaultServer.sh",
      "sleep 10"
    ]
  }
}
