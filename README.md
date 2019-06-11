# SecuringBaremetal
Best Practices for Securing Services on Bare Metal



## The Fortune Cookie Service

```
socat -v tcp-l:8181,bind=0,fork exec:/usr/games/fortune
```




## Initial Unsecure Deployment


```
+---------------------------------------+                              +--------------------------------------+
|                                       |                              |                                      |
| Fortune Cookie Service (FCS)          |                              | Fortune Cookie Consumer (FCC)        |
| TCP port 8181                         |                              |                                      |
|                                       +----------------------------->+                                      |
| Physical Server (Bare Metal)          |    unauthenticated request   | Physical Server (Bare Metal)         |
| t1.small.x86                          |                              | t1.small.x86                         |
| fcs-00                                +<-----------------------------+ fcc-00                               |
|                                       |    unencrypted traffic       |                                      |
|                                       |                              |                                      |
+---------------------------------------+                              +--------------------------------------+
```

## Testing the Service

```
studarus@labs:~$ nc fcs00 8181
You will have long and healthy life.
studarus@labs:~$ nc fcs00 8181
Q:      What do you call a principal female opera singer whose high C
        is lower than those of other principal female opera singers?
A:      A deep C diva.
studarus@labs:~$ nc fcs00 8181
You love peace.
```

## Man in the Middle Attack

```
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

```
studarus@labs:~$ nc fcs00 8181
The holy passion of Friendship is of so sweet and steady and loyal and
enduring a nature that it will last through a whole lifetime, if not asked to
lend money.
                -- Mark Twain, "Pudd'nhead Wilson's Calendar"
```

```
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


## Improving Operational Security

* Prevent a Man in the Middle attack between the Fortune Cookie Service (FCS) and the Fortune Cookie Consumer (FCC). 
* No modifications of the service is allowed (source code or binary)
* Avoiding the overhead of VPN between 

Employ TLS (Transport Layer Security) using asymetrical and symetrical encryption.


## Introducing the Service Mesh Agent and Server


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

## Disable Unecrypted Public Service

Instead of binding to all the interfaces...
```
socat -v tcp-l:8181,bind=0,fork exec:/usr/games/fortune
```
just bind to the loopback.
```
socat -v tcp-l:8181,bind=127.0.0.1,fork exec:/usr/games/fortune
```

Remote hosts will no longer be able to reach TCP port 8181. Only processes on the localhost, such as the sidecar proxy, will be able to connect to the service. This has eliminated the risk of remote requests to the unencrypted service.

## What about?

### Access Control

### Authentication

### Service Resilience

### Encryption on Disk





