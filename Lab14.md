# Lab 14 - Service Resilience

## Managing Service Failure

The Service Mesh can improve service resilience by tracking multiple instances of each micro service as they start up, stop, and fail. The client side car agent uses the service registry to direct requests to the running instances.

### Scaling Up

The Terraform configuration file can be updated and reprocessed to spin up additional micro service instances.

### Registering new Service Instances

These instances are then registered with the Service Mesh. Registration makes these additional instances available to be consumed.

### Handling Failures

As the physical servers "fail", the Service Mesh will discover and remove that instance from  the registry. Requests are then sent to the other remaining servers.

## Next Steps

Once you're done, proceed to [Lab15](Lab15.md)