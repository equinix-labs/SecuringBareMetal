# Service Mesh 12 - Bringing the Service Mesh Online

## Starting the Consul Server

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

## The Service Mesh Agent

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

## The Side Car

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

## Next Steps

Once you're done, proceed to [ServiceMesh13](ServiceMesh13.md)
