resource "packet_device" "fcs" {

  depends_on       = ["packet_ssh_key.host_key"]

  project_id       = "${var.packet_project_id}"
  facilities       = "${var.facilities}"
  plan             = "${var.plan}"
  operating_system = "${var.operating_system}"
  hostname         = "${format("fcs-%02d", count.index)}"

  count            = "${var.fcs_count}"

  billing_cycle    = "hourly"
  tags             = ["${var.build}","fcs"]

  connection {
    user        = "root"
    private_key = "${file("${var.private_key_filename}")}"
  }

  provisioner "remote-exec" {
    inline = [
      "ssh-keygen -A",
      "sudo apt-add-repository ppa:zanchey/asciinema -y",
      "apt-get update -y >> apt.out",
      "DEBIAN_FRONTEND=noninteractive apt-get install tcpflow dnsutils zip asciinema lvm2 cryptsetup -y >> apt.out",
      "mkdir -p /etc/consul.d",
      "mkdir -p /usr/share/games/fortunes",
      "dd if=/dev/zero of=/opt/fortune.img bs=1M count=1200",
      "losetup /dev/loop0 /opt/fortune.img",
      "mkfs.ext4 /dev/loop0",
      "mount /dev/loop0 /usr/share/games/fortunes",
      "DEBIAN_FRONTEND=noninteractive apt-get install fortune -y >> apt.out",
    ]
  }

  provisioner "file" {
    source      = "consul-client-config.json"
    destination = "/etc/consul.d/consul-client-config.json"
  }

  provisioner "file" {
    source      = "FortuneService.json"
    destination = "/etc/consul.d/FortuneService.json"
  }

  provisioner "file" {
    source      = "FortuneSecureService.json"
    destination = "FortuneSecureService.json"
  }

  provisioner "file" {
    source      = "StartConsul.sh"
    destination = "/usr/local/bin/StartConsul.sh"
  }

  provisioner "file" {
    source      = "StartFortune.sh"
    destination = "/usr/local/bin/StartFortune.sh"
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
      "chmod 755 /usr/local/bin/StartFortune.sh",
      "screen -dmS fortune /usr/local/bin/StartFortune.sh",
      "sleep 10"
    ]
  }
}
