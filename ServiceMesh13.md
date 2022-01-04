# Service Mesh 13 - Securing the Micro Services with the Service Mesh

With the Service Mesh server and client agent running, the micro service can now be secured.

## Registering Secure Service

The unsecure service will be removed from the registration and a new secure service that runs through the side car proxy will replace it. This secure service provides encryption and authentication.

## Consuming the Secure Service

The client can now consume the service through the client side car proxy which connects over the network to the to the server side car proxy which in turn connects to the micro service over a local (on host) connection.

## Restricting Unencrypted Public Service

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

## Next Steps

Once you're done, proceed to [ServiceMesh14](ServiceMesh14.md)
