
variable "packet_auth_token" {
  description = "Your Packet Authentication Token"
}

variable "packet_project_id" {
  description = "Your Packet Project ID"
}

variable "public_key_filename" {
  description = "SSH public key to be placed into deployed bare metal hosts"
  default     = "~/.ssh/id_rsa.pub"
}

variable "private_key_filename" {
  description = "SSH private key associated with public key"
  default     = "~/.ssh/id_rsa"
}

# for a full list of facilities, see: https://www.packet.com/developers/api/#facilities
variable "facilities" {
  description = "Prioritized list of facilities (data center) to deploy bare metal hosts"
  default     = ["ewr1"]
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
  description = "Set the Packet server type"
  default     = "t1.small.x86"
}

variable "operating_system" {
  description = "Base operating system to install on bare metal hosts"
  default     = "ubuntu_16_04"
}

variable "build" {
  description = "Build number which is added as a tag to hosts"
  default     = ""
}
