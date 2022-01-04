
variable "metal_auth_token" {
  description = "Your Equinix Metal Authentication Token"
}

variable "metal_project_id" {
  description = "Your Equinix Metal Project ID"
}

variable "public_key_filename" {
  description = "SSH public key to be placed into deployed bare metal hosts"
  default     = "~/.ssh/id_rsa.pub"
}

variable "private_key_filename" {
  description = "SSH private key associated with public key"
  default     = "~/.ssh/id_rsa"
}

# for a full list of metros, see: https://metal.equinix.com/developers/docs/locations/metros/
variable "metro" {
  description = "Metro to deploy bare metal hosts"
  default     = "sv"
}

variable "consul_count" {
  description = "Number of Consul server bare metal hosts to spin up"
  default     = "3"
}

variable "vault_count" {
  description = "Number of Vault server bare metal hosts to spin up"
  default     = "0"
}

variable "fcc_count" {
  description = "Number of fortune cookie consumer bare metal hosts to spin up"
  default     = "1"
}

variable "fcs_count" {
  description = "Number of fortune cookie service bare metal hosts to spin up"
  default     = "3"
}

variable "plan" {
  description = "Set the Equinix Metal server type"
  default     = "c3.small.x86"
}

variable "operating_system" {
  description = "Base operating system to install on bare metal hosts"
  default     = "ubuntu_20_04"
}

variable "build" {
  description = "Build number which is added as a tag to hosts"
  default     = ""
}
