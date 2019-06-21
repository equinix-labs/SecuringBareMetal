# Lab 10 - Physical Infrastructure Deployment

## Background

Terraform is used to deploy the physical infrastructure and install the required software components on the deployed server. The initial deployment will consist of 5 bare metal hosts with 3 being redundant Consol service mesh servers, one a micro service (Fortune Cookie Server), and the one being a micro service consumer (Fortune Cookie Consumer).

## Bare Metal Infrastructure

| Node          | CPU cores      | Memory (GB) | Boot (GB SSD) | Details
|---------------|----------------|-------------|---------------|---------------------------------------------------------------
| Consul{0-2}   | 4 x 2.4 GHz    | 8 GB        | 1 x 80        | [t1.small.x86](https://www.packet.com/cloud/servers/t1-small/)
| fcs00         | 4 x 2.4 GHz    | 8 GB        | 1 x 80        | [t1.small.x86](https://www.packet.com/cloud/servers/t1-small/)
| fcc01         | 4 x 2.4 GHz    | 8 GB        | 1 x 80        | [t1.small.x86](https://www.packet.com/cloud/servers/t1-small/)

## Deploying with Terraform

Terraform will deploy the requested infrastructure calling the appropriate bare metal cloud APIs at Packet. Terraform has a plugin architecture allowing it to "talk" to public and private cloud APIs (i.e. AWS, Azure, OpenStack, Packet, etc).

A Terraform configuration describes the final infrastructure state (i.e. number and type of physical or VM servers). Terraform uses this to determine how and in what order to deploy infrastructure.

## Consul Server Terraform Configuration

The following deployes the "Consul Server" 
```
resource "packet_device" "consul_server" {

  depends_on       = ["packet_ssh_key.host_key"]

  project_id       = "${var.packet_project_id}"
  facilities       = "${var.facilities}"
  plan             = "${var.plan}"
  operating_system = "${var.operating_system}"
  hostname         = "${format("consul%02d", count.index)}"

  # should be an odd number
  # > 1 will require update to the consul config file bootstrap values
  count            = "${var.consul_count}"
...
```

The "variables.tf" describes the configurable components of the final system such as the total number of servers to deploy, the size of each server, and the data center to use.

```
# for a full list of facilities, see: https://www.packet.com/developers/api/#facilities
variable "facilities" {
  description = "Prioritized list of facilities (data center) to deploy bare metal hosts"
  default     = ["ewr1"]
}

variable "consul_count" {
  description = "Number of Consul server bare metal hosts to spin up"
  default     = "3"
}

variable "fcc_count" {
  description = "Number of fortune cookie consumer bare metal hosts to spin up"
  default     = "1"
}

variable "fcs_count" {
  description = "Number of fortune cookie service bare metal hosts to spin up"
  default     = "1"
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
```


## Next Steps

Once you're done, proceed to [Lab11](Lab11.md)