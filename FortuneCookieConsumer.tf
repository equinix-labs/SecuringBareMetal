resource "metal_device" "fcc" {

  depends_on = [metal_ssh_key.host_key]

  project_id       = var.metal_project_id
  metro            = var.metro
  plan             = var.plan
  operating_system = var.operating_system
  hostname         = format("fcc%02d", count.index)

  count = var.fcc_count

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
      "apt-get install nginx tcpflow dnsutils zip asciinema -y >> apt.out",
      "mkdir -p /etc/consul.d",
    ]
  }

  provisioner "file" {
    source      = "${path.module}/assets/consul-client-config.json"
    destination = "/etc/consul.d/consul-client-config.json"
  }

  provisioner "file" {
    source      = "${path.module}/assets/StartConsulClient.sh"
    destination = "/usr/local/bin/StartConsul.sh"
  }

  provisioner "file" {
    source      = "${path.module}/assets/consul_install.sh"
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
