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

Key-management (sometimes also called secrets-management) solutions store, manage and provide access to secret parameters such as cryptographic keys, credentials, authentication tokens, etc. Development teams need to share data, configurations, and access keys across teams to cooperate on application development and testing. 
Automated build servers need access to source code control, API gateways, and user roles to accomplish their tasks. 
Servers need access to encrypted disks, applications need to access databases, and containers must be provisioned with privileges as they start up. 
Automated services cannot wait around for an administrator to type in passwords or provide credentials. Secrets management platforms address these requirements.

Some popular secrets management solutions include Hashicorp Vault, CyberArk Conjure, etcd and Square Keywhiz. 
These solutions are mostly open-source, with Hashicorp offering an enterprise version for Vault with features like HSM integration and more.

While the data used by secrets management platforms is typically secured at-rest and in-transit, secrets information is in the clear and unprotected at runtime. Bad actors can compromise secrets while the data is in use. For example, hackers or malicious insiders can parse data-in-use to obtain the encryption keys for data-at-rest or certificates for intercepting data-in-transit. To better understand the security model of Vault, and what is outside of it, refer to [the Security Model in Vault's documentation ](https://www.vaultproject.io/docs/internals/security.html), or to the following [webinar on runtime protection for secrets management](https://youtu.be/7zUOp4MDAI0).

Hashicorp provides useful [production hardening guidelines](https://learn.hashicorp.com/vault/operations/production-hardening) for securing Vault, which can apply to other secrets-management solutions, or sensitive application in general, as well. 
The challenge with this approach, is that hardening a whole host is hard, requires securing a large perimeter, and most importantly [leaves unaddressed multiple security and privacy concerns](https://youtu.be/7zUOp4MDAI0).
New approaches include Runtime Security where an application is protected on a CPU level using novel secure enclave technologies that secure the application even in case an attacker gains root access to the host. For instance, [Anjuna](www.anjuna.io) provides a runtime security solution for that seamlessly enables this level of security for Vault. See the [Anjuna documentation](https://docs.anjuna.io/vault-sgx) for more details.

## Securing Data at Rest with Disk Encryption

Stay tuned


