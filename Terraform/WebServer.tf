resource "packet_device" "web" {

  depends_on       = ["packet_ssh_key.host_key"]

  project_id       = "${var.packet_project_id}"
  facilities       = "${var.facilities}"
  plan             = "${var.plan}"
  operating_system = "${var.operating_system}"
  hostname         = "${format("web-%02d", count.index)}"

  count            = "${var.webserver_count}"

  billing_cycle    = "hourly"
  tags             = ["${var.build}","webserver"]

  connection {
    user        = "root"
    private_key = "${file("${var.private_key_filename}")}"
  }
}
