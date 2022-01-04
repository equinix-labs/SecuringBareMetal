resource "metal_device" "fcs" {

  depends_on = [metal_ssh_key.host_key]

  project_id       = var.metal_project_id
  metro            = var.metro
  plan             = var.plan
  operating_system = var.operating_system
  hostname         = format("fcs%02d", count.index)

  count = var.fcs_count

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
      "DEBIAN_FRONTEND=noninteractive apt-get install tcpflow dnsutils zip asciinema encfs -y >> apt.out",
      "mkdir -p /etc/consul.d",
      "mkdir -p /etc/vault.d",
      "mkdir -p /usr/share/games/fortunes-raw",
      "mkdir -p /usr/share/games/fortunes",
      "echo topsecret | encfs -S /usr/share/games/fortunes-raw /usr/share/games/fortunes",
      "DEBIAN_FRONTEND=noninteractive apt-get install fortune -y >> apt.out",
    ]
  }

  provisioner "file" {
    source      = "${path.module}/assets/consul-client-config.json"
    destination = "/etc/consul.d/consul-client-config.json"
  }

  provisioner "file" {
    source      = "${path.module}/assets/FortuneService.json"
    destination = "/etc/consul.d/FortuneService.json"
  }

  provisioner "file" {
    source      = "${path.module}/assets/FortuneSecureService.json"
    destination = "FortuneSecureService.json"
  }

  provisioner "file" {
    source      = "${path.module}/assets/StartConsulClient.sh"
    destination = "/usr/local/bin/StartConsul.sh"
  }

  provisioner "file" {
    source      = "${path.module}/assets/StartFortune.sh"
    destination = "/usr/local/bin/StartFortune.sh"
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
      "chmod 755 /usr/local/bin/StartFortune.sh",
      "screen -dmS fortune /usr/local/bin/StartFortune.sh",
      "sleep 10"
    ]
  }

  provisioner "file" {
    source      = "${path.module}/assets/vault-client-config.json"
    destination = "/etc/vault.d/vault-client-config.json"
  }

  provisioner "file" {
    source      = "${path.module}/assets/StartVaultClient.sh"
    destination = "/usr/local/bin/StartVaultClient.sh"
  }

  provisioner "file" {
    source      = "${path.module}/assets/vault_install.sh"
    destination = "vault_install.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "bash vault_install.sh > vault_install.out",
      "chmod 755 /usr/local/bin/StartVaultClient.sh",
      "screen -dmS vault /usr/local/bin/StartVaultClient.sh",
      "sleep 10"
    ]
  }
}
