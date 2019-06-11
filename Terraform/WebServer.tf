resource "packet_device" "web" {

  depends_on       = ["packet_ssh_key.host_key"]

  project_id       = "${var.packet_project_id}"
  facilities       = "${var.facilities}"
  plan             = "${var.plan}"
  operating_system = "${var.operating_system}"
  hostname         = "${format("web%02d", count.index)}"

  count            = "${var.webserver_count}"

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
      "apt-get install nginx tcpflow dnsutils zip asciinema -y >> apt.out",
      "mkdir -p /etc/consul.d",
    ]
  }

  provisioner "file" {
    source      = "consul-client-config.json"
    destination = "/etc/consul.d/consul-client-config.json"
  }

  provisioner "file" {
    source      = "StartConsul.sh"
    destination = "/usr/local/bin/StartConsul.sh"
  }

  provisioner "file" {
    source      = "consul_install.sh"
    destination = "consul_install.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "bash consul_install.sh > consul_install.out",
      "chmod 755 /usr/local/bin/StartConsul.sh",
      "screen -dmS consul /usr/local/bin/StartConsul.sh",
      "sleep 10"
    ]
  }
}
