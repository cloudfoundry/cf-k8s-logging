# cf-k8s-logging

cf-k8s-logging contains the portions of cf-for-k8s which enable logging
outcomes.

## API

### App Containers
Logs from app containers are automatically ingested and egressed from
cf-k8s-logging. App containers are expected to contain `cloudfoundry.org/`
labels which contain important app information, namely `app_guid` and
`source_type`.

### System Components/Injected Logs
Cloud Foundry components that wish to emit logs on behalf of apps may do so via the
[Fluentd forward input](https://docs.fluentd.org/input/forward). This protocol
consists of tagged log messages encoded in MessagePack over TCP.
Injected logs will be sent to the same destinations as app container logs, as long
as they contain the tags listed below under [Log Format](#log-format).

Logs should be sent to the Fluentd ingress service called
`fluentd-forwarder-ingress` at port `24224` over the Fluent forwarding
protocol. This protocol can be implemented using one of the following client libraries:
 
* https://github.com/fluent/fluent-logger-ruby
* https://github.com/fluent/fluent-logger-golang
* https://github.com/fluent/fluent-logger-java

or by placing a Fluentd/Fluent Bit pod next to the component with a [`forward` output plugin](https://docs.fluentd.org/output/forward).

Examples are located [in the examples folder](examples).

***NOTE:***  To communicate with the Forwarder API, Istio sidecar injection
must be enabled with the `istio-injection=enabled` label in the component's
namespace.

#### Log Format
Logs emitted to cf-k8s-logging by system components must include the fields:
- `app_id`: id of the app for which the logs are being emitted.
- `instance_id`: id of the instance for which the logs are being emitted.
- `source_type`: source type of the logs. eg. STG
- `log`: log message to emit

```
{"log":"This is a test log from a fluent log producer","app_id":"11111111-1111-1111-1111-111111111111","instance_id":"1", "source_type":"APP"}
```
## Development flow

1. Make needed updates (update vendir, update k8s files, etc).
1. Make local commit (allows reverting of image tags).
1. Run `./scripts/build-images.sh`, setting $REPOSITORY to a docker
   repository you can push to.
1. Run `./scripts/bump-cf-for-k8s.sh` .
1. Follow cf-for-k8s deployment steps.

### Debug logging in cf-k8s-logging fluentd

To diagnose issues with Fluentd, you can increase the log level by setting the
environment variable `FLUENTD_FLAGS` on Fluentd, like so
```
env:
- name: "FLUENTD_FLAGS"
  value: "-vvv"
```

`-vvv` is the highest logging level

Another way to see what is being sent is by replacing the output with a stdout
logger:
```
<match **>
    @type stdout
</match>
```
