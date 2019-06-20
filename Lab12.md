# Lab 12 - 

## Starting Consul

### Bootstrap First Instance

### Joining Additional Agents

# Introducing the Service Mesh Agent and Server


### The Service Mesh Agent

```
+--------+-----------+                   +------------+----------+
|        |  fcs      |                   |  fcc       |          |
|  fcs00 |  8181     |                   |            | fcc00    |
|        +-----------+                   +------------+          |
|                    |                   |                       |
|        +-----------+                   +------------+          |
|        |fcs-sidecar|                   | fcc-sidecar|          |
|        |           |                   |            |          |
+--------------------+                   +------------+----------+
```

### The Service Mesh Server

```
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

### Leader Elections

### Joining Service Mesh Agents to Server
```
+-------+------------+                   +------------+----------+
|       |   fcs      |                   |  fcc       |          |
|  fcs00|   8181     |                   |            | fcc00    |
|       +------------+                   +------------+          |
|                    |                   |                       |
|       +------------+                   +------------+          |
|       | fcs-sidecar|                   | fcc-sidecar|          |
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



## Registering the Fortune Cookie Service

## Validating Encryption

```
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

Once you're done, proceed to [Lab13](Lab13.md)