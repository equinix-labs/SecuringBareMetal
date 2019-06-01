
resource "null_resource" "consul_join_fortune" {

  depends_on       = ["packet_device.consul_server"]

  count            = "${var.fcs_count}"

  connection {
    user        = "root"
    private_key = "${file("${var.private_key_filename}")}"
    host        = "${element(packet_device.fcs.*.access_public_ipv4,count.index)}"
  }

  provisioner "remote-exec" {
    inline = [
      "consul join ${packet_device.consul_server.access_private_ipv4}"
    ]
  }
}


resource "null_resource" "consul_join_web" {

  depends_on       = ["packet_device.consul_server"]

  count            = "${var.webserver_count}"

  connection {
    user        = "root"
    private_key = "${file("${var.private_key_filename}")}"
    host        = "${element(packet_device.web.*.access_public_ipv4,count.index)}"
  }

  provisioner "remote-exec" {
    inline = [
      "consul join ${packet_device.consul_server.access_private_ipv4}"
    ]
  }
}
