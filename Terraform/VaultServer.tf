resource "packet_device" "vault_server" {

  depends_on       = ["packet_ssh_key.host_key"]

  project_id       = "${var.packet_project_id}"
  facilities       = "${var.facilities}"
  plan             = "${var.plan}"
  operating_system = "${var.operating_system}"
  hostname         = "${format("vault%02d", count.index)}"

  # should be an odd number
  # > 1 will require update to the consul config file bootstrap values
  count            = "${var.vault_count}"

  billing_cycle    = "hourly"

  connection {
    user        = "root"
    private_key = "${file("${var.private_key_filename}")}"
  }

  provisioner "remote-exec" {
    inline = [
      "ssh-keygen -A",
      "sudo apt-add-repository ppa:zanchey/asciinema -y",
      "apt-get update -y >> apt.out",
      "apt-get install fortune tcpflow dnsutils zip asciinema -y >> apt.out",
      "mkdir -p /etc/vault.d",
    ]
  }

  provisioner "file" {
    source      = "vault-server-config.json"
    destination = "/etc/vault.d/vault-server-config.json"
  }

  provisioner "file" {
    source      = "StartVaultServer.sh"
    destination = "/usr/local/bin/StartVaultServer.sh"
  }

  provisioner "file" {
    source      = "vault_install.sh"
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
