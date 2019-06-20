# Lab 13 - 

## Service Management

### Registering Service

### Consuming Unsecure Service

### Registering Secure Service

### Service Side Car Proxy

### Consumer Side Car Proxy

### Consuming the Secure Service

## Restricting Unencrypted Public Service

Instead of binding to all the interfaces...
```
socat -v tcp-l:8181,bind=0,fork exec:/usr/games/fortune
```
just bind to the loopback.
```
socat -v tcp-l:8181,bind=127.0.0.1,fork exec:/usr/games/fortune
```

Remote hosts will no longer be able to reach TCP port 8181. Only processes on the localhost, such as the sidecar proxy, will be able to connect to the service. This has eliminated the risk of remote requests to the unencrypted service.





## Next Steps

Once you're done, proceed to [Lab14](Lab14.md)