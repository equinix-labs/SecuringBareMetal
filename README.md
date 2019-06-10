# SecuringBaremetal
Best Practices for Securing Services on Bare Metal




## Initial Unsecure Deployment

Exposed service
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



## Man in the Middle Attack

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

## The Service Mesh Server

## The Service Mesh Agent "Sidecar"

## Registering the Fortune Cookie Service

## Validating Encryption

## Disable Unecrypted Public Service

## 





