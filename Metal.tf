#
# the Equinix Metal provider by default looks for an environment variable TF_VAR_auth_token
# if desired, you can change the variable name here and in variables.tf
# 


provider "metal" {
  auth_token = var.metal_auth_token
}
