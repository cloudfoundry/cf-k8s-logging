# cf-k8s-logging

### Pushing Images to a Harbor Tile in an Ops Manager

1. Add harbor.SYSTEM_DOMAIN:443 to insecure registries (add as command-line argument when starting docker daemon, or in UI)
1. Login to docker registry (password is in credentials tab in Harbor tile of OpsMan)
   `docker login harbor.SYSTEM_DOMAIN:443 -u admin`
1. Build your image with tags for Harbor
   `docker build . --tag harbor.SYSTEM_DOMAIN:443/library/cf-k8s-logging:TAG`
1. Push to Harbor
   `docker push harbor.SYSTEM_DOMAIN:443/library/cf-k8s-logging:TAG`
1. Modify the fluentd-daemonset
1. Login to PKS `pks login -a https://api.SYSTEM_DOMAIN -k -u admin` with the UAA admin
1. Get credentials for the pks cluster `pks get-credentials CLUSTER-NAME` (which allows you to use `kubectl`)
1. Create a docker registry secret
```
kubectl create \
  secret docker-registry image-registry-credentials \
  --docker-server="harbor.SYSTEM_DOMAIN:443"  \
  --docker-username="admin" \
  --docker-password="UAA-ADMIN"
```

1. Generate and upload certs using init_certs.sh and kubernetes-create-secrets.sh
1. Deploy all the objects to kubernetes.
1. (possibly restart fluentd pods if things arn't coming through)
```
kubectl apply -f .
```
1. See the logs from your CF pushed apps! (To test, try out logspinner)
