
resource "null_resource" "consul_join_server" {

  depends_on       = ["packet_device.consul_vault_server"]

  count            = "${var.consul_vault_count}"

  connection {
    user        = "root"
    private_key = "${file("${var.private_key_filename}")}"
    host        = "${element(packet_device.consul_vault_server.*.access_public_ipv4,count.index)}"
  }

  provisioner "remote-exec" {
    inline = [
      "consul join ${element(packet_device.consul_vault_server.*.access_private_ipv4,0)}"
    ]
  }
}

resource "null_resource" "consul_join_fortune" {

  depends_on       = ["packet_device.consul_vault_server"]

  count            = "${var.fcs_count}"

  connection {
    user        = "root"
    private_key = "${file("${var.private_key_filename}")}"
    host        = "${element(packet_device.fcs.*.access_public_ipv4,count.index)}"
  }

  provisioner "remote-exec" {
    inline = [
      "consul join ${element(packet_device.consul_vault_server.*.access_private_ipv4,0)}"
    ]
  }
}


resource "null_resource" "consul_join_fcc" {

  depends_on       = ["packet_device.consul_vault_server"]

  count            = "${var.fcc_count}"

  connection {
    user        = "root"
    private_key = "${file("${var.private_key_filename}")}"
    host        = "${element(packet_device.fcc.*.access_public_ipv4,count.index)}"
  }

  provisioner "remote-exec" {
    inline = [
      "consul join ${element(packet_device.consul_vault_server.*.access_private_ipv4,0)}"
    ]
  }
}
