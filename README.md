![](https://img.shields.io/badge/Stability-Experimental-red.svg)

This repository is [Experimental](https://github.com/equinix-labs/equinix-labs/blob/main/experimental-statement.md) meaning that it's based on untested ideas or techniques and not yet established or finalized or involves a radically new and innovative style! This means that support is best effort (at best!) and we strongly encourage you to NOT use this in production.

# Securing Baremetal

Zero Trust is an information security mantra that implements security controls such as encryption so that the underlying infrastructure (hardware, network, software, etc) need not be implicitly trusted. For many organizations, this extends into the cloud where this philosophy is applied to workloads running in public, virtualized clouds. While there are security controls in place in the underlying cloud infrastructure, many organizations follow the Zero Trust model to add in an extra layer of security. This repo follows these ideas to take an unsecure application, the Fortune Cookie Micro Service, running atop a bare metal cloud and add in the additional security layers to protect the data on disk and in motion.

## Video Walk Through

A walk through of this content deployed and running is available online: <https://youtu.be/PyV_h1mbw2w>. The recording contains dated branding, follow this guide for the most up to date references.

## Securing Data in Motion with Service Mesh

Securing Data in Motion as it traverses the physical network can be accomplished with a Service Mesh. This layer of software introduces client and server side authentication and encryption using TLS (transport layer security). The steps below cover the deployment and setup of the Service Mesh atop bare metal infrastructure as well as the securing of the Fortune Cookie Micro Service through the Service Mesh.

* [Physical Infrastructure Deployment for a Bare Metal Service Mesh](#physical-infrastructure-deployment-for-a-bare-metal-service-mesh)
* [The Micro Services](#the-micro-services)
* [Bringing the Service Mesh Online](#bringing-the-service-mesh-online)
* [Securing the Micro Services with the Service Mesh](#securing-the-micro-services-with-the-service-mesh)
* [Micro Service Resilience through the Service Mesh](#micro-service-resilience-through-the-service-mesh)

## Physical Infrastructure Deployment for a Bare Metal Service Mesh

### Background

Terraform is used to deploy the physical infrastructure and install the required software components on the deployed server. The initial deployment will consist of 5 bare metal hosts with 3 being redundant Consol service mesh servers, one a micro service (Fortune Cookie Server), and the one being a micro service consumer (Fortune Cookie Consumer).

### Bare Metal Infrastructure

| Node        | CPU cores   | Memory (GB) | Boot (GB SSD) | Details                                                             |
| ----------- | ----------- | ----------- | ------------- | ------------------------------------------------------------------- |
| Consul{0-2} | 8 x 3.4 GHz | 32 GB       | 2 x 480       | [c3.small.x86](https://metal.equinix.com/product/servers/c3-small/) |
| fcs00       | 8 x 3.4 GHz | 32 GB       | 2 x 480       | [c3.small.x86](https://metal.equinix.com/product/servers/c3-small/) |
| fcc01       | 8 x 3.4 GHz | 32 GB       | 2 x 480       | [c3.small.x86](https://metal.equinix.com/product/servers/c3-small/) |

### Deploying with Terraform

Terraform will deploy the requested infrastructure calling the appropriate bare metal cloud APIs at Equinix Metal. Terraform has a plugin architecture allowing it to "talk" to public and private cloud APIs (i.e. AWS, Azure, OpenStack, Equinix Metal, etc).

A Terraform configuration describes the final infrastructure state (i.e. number and type of physical or VM servers). Terraform uses this to determine how and in what order to deploy infrastructure.

### Consul Server Terraform Configuration

The following deploys the "Consul Server"

```hcl
resource "metal_device" "consul_server" {

  depends_on       = ["metal_ssh_key.host_key"]

  project_id       = var.metal_project_id
  metro            = var.metro
  plan             = var.plan
  operating_system = var.operating_system
  hostname         = "${format("consul%02d", count.index)}"

  # should be an odd number
  # > 1 will require update to the consul config file bootstrap values
  count            = var.consul_count
...
```

The "variables.tf" describes the configurable components of the final system such as the total number of servers to deploy, the size of each server, and the data center to use.

```hcl
# for a full list of metros, see: https://metal.equinix.com/developers/docs/locations/metros/
variable "metro" {
  description = "Metro to deploy bare metal hosts"
  default     = "sv"
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
```

## The Micro Services

### Fortune Cookie Service

The Fortune Cookie (Micro) Service provides insightful fortunes via a TCP connection. It is unauthenticated and unencrypted.

```sh
socat -v tcp-l:8181,bind=0,fork exec:/usr/games/fortune
```

#### Testing the FCS

Netcat can be used to validate that the FCS is working properly.

```sh
studarus@labs:~$ nc fcs00 8181
You will have long and healthy life.
studarus@labs:~$ nc fcs00 8181
Q:      What do you call a principal female opera singer whose high C
        is lower than those of other principal female opera singers?
A:      A deep C diva.
studarus@labs:~$ nc fcs00 8181
You love peace.
```

#### Deployed Infrastructure

One bare metal server is deployed running the FCS and a second as the micro service consumer.

```console
+---------------------------------------+                              +--------------------------------------+
|                                       |                              |                                      |
| Fortune Cookie Service (FCS)          |                              | Fortune Cookie Consumer (FCC)        |
| TCP port 8181                         |                              |                                      |
|                                       +----------------------------->+                                      |
| Physical Server (Bare Metal)          |    unauthenticated request   | Physical Server (Bare Metal)         |
| t1.small.x86                          |                              | t1.small.x86                         |
| fcs00                                 +<-----------------------------+ fcc00                                |
|                                       |    unencrypted traffic       |                                      |
|                                       |                              |                                      |
+---------------------------------------+                              +--------------------------------------+
```

#### Man in the Middle Attack

Since this traffic runs across public network infrastructure in an unencrypted format it is vulnerable to a "man in the middle" snooping and possible modification.

```console
                        Man in the Middle
                        TCPDump/TCPFlow
+------------------+    "Reads" traffic           +----------------+
|                  |             +                |                |
|                  |             |                |                |
| fcs-00           |             |                | fcc-00         |
|                  |             |                |                |
|                  |             v                |                |
|                  +-------------+----------------+                |
|                  |     unencrypted traffic      |                |
|                  |                              |                |
|                  |                              |                |
+------------------+                              +----------------+
```

Consider this execution of the micro service...

```sh
studarus@labs:~$ nc fcs00 8181
The holy passion of Friendship is of so sweet and steady and loyal and
enduring a nature that it will last through a whole lifetime, if not asked to
lend money.
                -- Mark Twain, "Pudd'nhead Wilson's Calendar"
```

A TCP Dump session was able to view this data as it was transmitted across the network. Since we consider fortunes to be private and confidential, this is a serious security issue that needs to be addressed!

```console
01:20:20.000084 IP (tos 0x0, ttl 56, id 48043, offset 0, flags [DF], proto TCP (6), length 261)
    fcs00.8181 > 139.178.82.107.53396: Flags [P.], cksum 0xc307 (correct), seq 666152399:666152608, ack 300437032, win 114, options [nop,nop,TS val 152639084 ecr 1775708429], length 209
        0x0000:  4500 0105 bbab 4000 3806 b23d 934b 62a1  E.....@.8..=.Kb.
        0x0010:  8bb2 526b 1ff5 d094 27b4 adcf 11e8 4e28  ..Rk....'.....N(
        0x0020:  8018 0072 c307 0000 0101 080a 0919 166c  ...r...........l
        0x0030:  69d7 290d 5468 6520 686f 6c79 2070 6173  i.).The.holy.pas
        0x0040:  7369 6f6e 206f 6620 4672 6965 6e64 7368  sion.of.Friendsh
        0x0050:  6970 2069 7320 6f66 2073 6f20 7377 6565  ip.is.of.so.swee
        0x0060:  7420 616e 6420 7374 6561 6479 2061 6e64  t.and.steady.and
        0x0070:  206c 6f79 616c 2061 6e64 0a65 6e64 7572  .loyal.and.endur
        0x0080:  696e 6720 6120 6e61 7475 7265 2074 6861  ing.a.nature.tha
        0x0090:  7420 6974 2077 696c 6c20 6c61 7374 2074  t.it.will.last.t
        0x00a0:  6872 6f75 6768 2061 2077 686f 6c65 206c  hrough.a.whole.l
        0x00b0:  6966 6574 696d 652c 2069 6620 6e6f 7420  ifetime,.if.not.
        0x00c0:  6173 6b65 6420 746f 0a6c 656e 6420 6d6f  asked.to.lend.mo
        0x00d0:  6e65 792e 0a09 092d 2d20 4d61 726b 2054  ney....--.Mark.T
        0x00e0:  7761 696e 2c20 2250 7564 6427 6e68 6561  wain,."Pudd'nhea
        0x00f0:  6420 5769 6c73 6f6e 2773 2043 616c 656e  d.Wilson's.Calen
        0x0100:  6461 7222 0a                             dar".
```

## Bringing the Service Mesh Online

### Starting the Consul Server

We've spun up three bare metal servers with Consul, the service mesh software, installed. They will need to be clustered together for reliability. This involves bootstrapping the first server and then joining the other two.

As the software clusters itself, it'll elect a leader which handles all communications and passes along state to the other Consul servers.

```console
     +------------------------------+
     | consul02                     |
  +--+---------------------------+  |
  | consul01                     |  |
+-+---------------------------+  |  |
|                             |  |  |
| Service Mesh Server         |  |  |
| Consul                      |  |  |
| t1.small.x86                |  |  |
| Physical Bare Metal         |  |  |
| consul00                    |  +--+
|                             |  |
|                             +--+
|                             |
+-----------------------------+
```

### The Service Mesh Agent

On the client side (FCS and FCC), the service mesh agent is run. This agent will communicate to the Consul elected leader.

```console
+-------+------------+                   +------------+----------+
|       |   fcs      |                   |  fcc       |          |
|  fcs00|   8181     |                   |            | fcc00    |
|       +------------+                   +------------+          |
|                    |                   |                       |
|       +------------+                   +------------+          |
|       |            |                   |            |          |
|       | SM Agent   |                   | SM Agent   |          |
+-------+-----+------+                   +---------+--+----------+
              |                                    |
              |                                    |
              |     +---------------------------+  |
              |     |  Service Mesh Server      |  |
              |     |  consul{00,01,02}         |  |
              +----->  One leader               <--+
                    +---------------------------+
```

### The Side Car

A side car is started up for each service and consumer that acts as a proxy authenticating and encrypting traffic across the network.

```console
+--------+-----------+                   +------------+----------+
|        |  fcs      |                   |  fcc       |          |
|  fcs00 |  8181     |                   |            | fcc00    |
|        +----^------+                   +---+--------+          |
|             |      |                   |   |                   |
|        +----+------+                   +---v--------+          |
|        |fcs-sidecar|                   | fcc-sidecar|          |
|        |9191       +<------------------+ 9191       |          |
+--------------------+                   +------------+----------+
```

## Securing the Micro Services with the Service Mesh

With the Service Mesh server and client agent running, the micro service can now be secured.

### Registering Secure Service

The unsecure service will be removed from the registration and a new secure service that runs through the side car proxy will replace it. This secure service provides encryption and authentication.

### Consuming the Secure Service

The client can now consume the service through the client side car proxy which connects over the network to the to the server side car proxy which in turn connects to the micro service over a local (on host) connection.

### Restricting Unencrypted Public Service

The micro service is removed from public view by binding to the loopback instead of a public IP.

Instead of binding to all the interfaces...

```sh
socat -v tcp-l:8181,bind=0,fork exec:/usr/games/fortune
```

just bind to the loopback.

```sh
socat -v tcp-l:8181,bind=127.0.0.1,fork exec:/usr/games/fortune
```

Remote hosts will no longer be able to reach TCP port 8181. Only processes on the localhost, such as the sidecar proxy, will be able to connect to the service. This has eliminated the risk of remote requests to the unencrypted service.

## Micro Service Resilience through the Service Mesh

### Managing Service Failure

The Service Mesh can improve service resilience by tracking multiple instances of each micro service as they start up, stop, and fail. The client side car agent uses the service registry to direct requests to the running instances.

#### Scaling Up

The Terraform configuration file can be updated and reprocessed to spin up additional micro service instances.

#### Registering new Service Instances

These instances are then registered with the Service Mesh. Registration makes these additional instances available to be consumed.

#### Handling Failures

As the physical servers "fail", the Service Mesh will discover and remove that instance from the registry. Requests are then sent to the other remaining servers.

### Next Steps

You've made it to the end!

Where do we go from here?

* Service Access Control
* Client and Service Side Authentication with Service Mesh
* Key Management and Rotation
* Securing Data at Rest with Disk Encryption
