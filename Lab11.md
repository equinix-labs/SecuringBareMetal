# Lab 11 - The Micro Services

## Fortune Cookie Service

The Fortune Cookie (Micro) Service provides insightful fortunes via a TCP connection. It is unauthenticated and unencrypted.

```
socat -v tcp-l:8181,bind=0,fork exec:/usr/games/fortune
```

### Testing the FCS

Netcat can be used to validate that the FCS is working properly.

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

### Deployed Infrastructure

One bare metal server is deployed running the FCS and a second as the micro service consumer.

```
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

### Man in the Middle Attack

Since this traffic runs across public network infrastructure in an unencrypted format it is vulnerable to a "man in the middle" snooping and possible modification.

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

Consider this execution of the micro service...

```
studarus@labs:~$ nc fcs00 8181
The holy passion of Friendship is of so sweet and steady and loyal and
enduring a nature that it will last through a whole lifetime, if not asked to
lend money.
                -- Mark Twain, "Pudd'nhead Wilson's Calendar"
```

A TCP Dump session was able to view this data as it was transmitted across the network. Since we consider fortunes to be private and confidential, this is a serious security issue that needs to be addressed!
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

## Next Steps

Once you're done, proceed to [Lab12](Lab12.md)