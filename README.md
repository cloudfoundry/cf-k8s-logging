# cf-k8s-logging

### Pushing Images to a Harbor Tile in an Ops Manager

1. Add harbor.SYSTEM_DOMAIN:443 to insecure registries (add as command-line argument when starting docker daemon, or in UI)
1. Login to docker (password is in credentials tab in Harbor tile of OpsMan)
   `docker login harbor.SYSTEM_DOMAIN:443 -u admin`
1. Update the fluent.conf file output section with your log destination and protocol
1. Clone git@github.com:loggregator/fluentd-syslog-rfc5424.git to fluent-plugin-syslog_rfc5424 in this directory
1. Build your image with tags for Harbor
   `docker build . --tag harbor.SYSTEM_DOMAIN:443/library/cf-k8s-logging:TAG`
1. Push to Harbor
   `docker push harbor.SYSTEM_DOMAIN:443/library/cf-k8s-logging:TAG`
1. Modify the fluentd-daemonset
1. Deploy the DaemonSet to a PAS4K8s:
```
kubectl apply -f \
  --docker-server="harbor.SYSTEM_DOMAIN:443"  \
  --docker-username="admin" \
  --docker-password="UAA-ADMIN"
```
1. See the logs from your CF pushed apps! (To test, try out logspinner)

### Note

DaemonSet was inspired by: https://github.com/fluent/fluentd-kubernetes-daemonset/blob/master/fluentd-daemonset-syslog.yaml