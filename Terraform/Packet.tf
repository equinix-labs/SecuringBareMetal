#
# the Packet provider by default looks for an environment variable TF_VAR_auth_token
# if desired, you can change the variable name here and in variables.tf
# 


provider "packet" {
  auth_token = "${var.packet_auth_token}"
}
