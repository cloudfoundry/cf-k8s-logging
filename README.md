# cf-k8s-logging

cf-k8s-logging contains the portions of cf-for-k8s which enable logging
outcomes.

## API

### App Containers
Logs from app containers are automatically ingested and egressed from
cf-k8s-logging. App containers are expected to contain cloudfoundry.org/
labels which contain important app information. Namely, app_guid, and
source_type.

### System Components/Injected Logs
Cf Components that wish to emit logs on behalf of apps may do so via the
[Forwarder Interface](https://docs.fluentd.org/output/forward). The core of the
fluent forward interface is sending MessagePack over TCP. Injected logs(as long
as they contain the necissary details in the format below) should be forwarded
to the appropriate downstream destinations.

The logs will be received by the fluent ingress service called
`fluentd-forwarder-ingress` at port `24224` using the fluent forwarding
protocol. Libraries can to forward can be found at
`https://github.com/fluent/fluent-logger-{ruby,golang,java}`, or a
fluent/fluentd can be configured to forward logs using an output plugin.

Examples are located [in the examples folder](examples)

***NOTE:***  To communicate with the Forwarder API, Istio sidecar injection
must be enabled with the `istio-injection=enabled` label in the component's
namespace.

#### Log Format
Logs emitted to cf-k8s-logging by system components must include the fields:
- app_id: id of the app for which the logs are being emitted.
- instance_id: id of the instance for which the logs are being emitted.
- source_type: source type of the logs. eg. STG
- log: log message to emit

```
{"log":"This is a test log from a fluent log producer","app_id":"11111111-1111-1111-1111-111111111111","instance_id":"1", "source_type":"APP"}
```
## Development flow

1. make updates needed (update vendir, update k8s files, etc).
1. make local commit(should make reverting image tags easy)
1. run build ./scripts/build-images.sh, setting $REPOSITORY to a docker
   repository you can push to
1. run ./scripts/bump-cf-for-k8s.sh
1. follow cf-for-k8s deployment steps.

### Debug logging in cf-k8s-logging fluentd

To investigate fluentd closer, you can up the log level by setting the
environment variable `FLUENTD_FLAGS` on fluentd, like so
```
env:
- name: "FLUENTD_FLAGS"
  value: "-vvv"
```

`-vvv` is the highest logging level

Another way to see what is being sent is replacing the output with a stdout
logger:
```
<match **>
    @type stdout
</match>
```
