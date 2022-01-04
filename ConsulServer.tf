resource "metal_device" "consul_server" {

  depends_on = [metal_ssh_key.host_key]

  project_id       = var.metal_project_id
  metro            = var.metro
  plan             = var.plan
  operating_system = var.operating_system
  hostname         = format("consul%02d", count.index)

  # should be an odd number
  # > 1 will require update to the consul config file bootstrap values
  count = var.consul_count

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
      "mkdir -p /etc/consul.d",
    ]
  }

  provisioner "file" {
    source      = "${path.module}/assets/consul-server-config.json"
    destination = "/etc/consul.d/consul-server-config.json"
  }

  provisioner "file" {
    source      = "${path.module}/assets/StartConsulServer.sh"
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
