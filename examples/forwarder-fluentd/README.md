# Example forwarder for app-related logs

These files allow you to deploy a fluentd that sends logs about an app to the cf-for-k8s logging system. The example will specifically emit logs for the app GUID `11111111-1111-1111-1111-111111111111`.

To try this out:

1. Make sure that the latest cf-k8s-logging is deployed (See ["Development flow" in the repo's README](/README.md#development-flow).
1. Set a fluentd image for the deployment to use (`fluent/fluentd` will work).
1. `kubectl apply -f .`
1. Wait for the deployment to finish, then examine the resulting logs via `cf tail 11111111-1111-1111-1111-111111111111` (from the [Log Cache CLI plugin](https://plugins.cloudfoundry.org/#log-cache)).
