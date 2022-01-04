
resource "null_resource" "consul_join_server" {

  depends_on = ["metal_device.consul_server"]

  count = var.consul_count

  connection {
    user        = "root"
    private_key = file("${var.private_key_filename}")
    host        = element(metal_device.consul_server.*.access_public_ipv4, count.index)
  }

  provisioner "remote-exec" {
    inline = [
      "consul join ${element(metal_device.consul_server.*.access_private_ipv4, 0)}"
    ]
  }
}

resource "null_resource" "consul_join_fortune" {

  depends_on = ["metal_device.consul_server"]

  count = var.fcs_count

  connection {
    user        = "root"
    private_key = file("${var.private_key_filename}")
    host        = element(metal_device.fcs.*.access_public_ipv4, count.index)
  }

  provisioner "remote-exec" {
    inline = [
      "consul join ${element(metal_device.consul_server.*.access_private_ipv4, 0)}"
    ]
  }
}


resource "null_resource" "consul_join_fcc" {

  depends_on = ["metal_device.consul_server"]

  count = var.fcc_count

  connection {
    user        = "root"
    private_key = file("${var.private_key_filename}")
    host        = element(metal_device.fcc.*.access_public_ipv4, count.index)
  }

  provisioner "remote-exec" {
    inline = [
      "consul join ${element(metal_device.consul_server.*.access_private_ipv4, 0)}"
    ]
  }
}
