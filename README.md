# SecuringBaremetal

Zero Trust is an information security mantra that implements security controls such as encryption so that the underlying infrastructure (hardware, network, software, etc) need not be implictly trusted. For many organizations, this extends into the cloud where this philosophy is applied to workloads running in public, virtualized clouds. While there are security controls in place in the underlying cloud infrastructure, many organizations follow the Zero Trust model to add in an extra layer of security. This repo follows these ideas to take an unsecure application, the Fortune Cookie Micro Service, running atop a bare metal cloud and add in the additional security layers to protect the data on disk and in motion.

## Video Walk Through

A walk through of this content deployed and running is available online: https://youtu.be/PyV_h1mbw2w

## Securing Data in Motion with Service Mesh

Securing Data in Motion as it traverses the physical network can be accomplished with a Service Mesh. This layer of software introduces client and server side authentication and encryption using TLS (transport layer security). The steps below cover the deployment and setup of the Service Mesh atop bare metal infrastructure as well as the securing of the Fortune Cookie Micro Service through the Service Mesh.


* Physical Infrastructure Deployment for a Bare Metal Service Mesh [ServiceMesh10](ServiceMesh10.md)
* The Micro Services [ServiceMesh11](ServiceMesh11.md)
* Bringing the Service Mesh Online [ServiceMesh12](ServiceMesh12.md)
* Securing the Micro Services with the Service Mesh [ServiceMesh13](ServiceMesh13.md)
* Micro Service Resilience through the Service Mesh [ServiceMesh14](ServiceMesh14.md)

## Client and Service Side Authentication with Service Mesh

Stay tuned

## Key Management

Stay tuned

## Securing Data at Rest with Disk Encryption

Stay tuned


