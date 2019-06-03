resource "packet_device" "vault_server" {

  depends_on       = ["packet_ssh_key.host_key"]

  project_id       = "${var.packet_project_id}"
  facilities       = "${var.facilities}"
  plan             = "${var.plan}"
  operating_system = "${var.operating_system}"
  hostname         = "${format("vault-%02d", count.index)}"

  count            = "1"

  billing_cycle    = "hourly"
  tags             = ["${var.build}","consul_server"]

  connection {
    user        = "root"
    private_key = "${file("${var.private_key_filename}")}"
  }

  provisioner "remote-exec" {
    inline = [
      "ssh-keygen -A",
      "sudo apt-add-repository ppa:zanchey/asciinema -y",
      "apt-get update -y >> apt.out",
      "apt-get install tcpflow dnsutils zip asciinema -y >> apt.out",
      "mkdir -p /etc/consul.d",
    ]
  }

  provisioner "file" {
    source      = "StartVault.sh"
    destination = "/usr/local/bin/StartVault.sh"
  }

  provisioner "file" {
    source      = "vault_install.sh"
    destination = "vault_install.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "bash vault_install.sh > vault_install.out",
      "chmod 755 /usr/local/bin/StartVault.sh",
      "screen -dmS vault /usr/local/bin/StartVault.sh",
      "sleep 10"
    ]
  }
}
