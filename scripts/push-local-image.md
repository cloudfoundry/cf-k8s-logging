# Pushing Images to a Harbor Tile in an Ops Manager

1. Add harbor.SYSTEM_DOMAIN:443 to insecure registries (add as command-line argument when starting docker daemon, or in UI)
1. Login to docker (password is in credentials tab in Harbor tile of OpsMan)
   `docker login harbor.SYSTEM_DOMAIN:443 -u admin`
1. Build your image with tags for Harbor
   `docker build . --tag harbor.SYSTEM_DOMAIN:443/library/cf-k8s-logging:TAG`
1. Push to Harbor
   `docker push harbor.SYSTEM_DOMAIN:443/library/cf-k8s-logging:TAG`


<!-- kubectl apply -f /
  --docker-server="harbor.poway.cf-app.com:443"  \
  --docker-username="admin" \
  --docker-password="MaMh6GctseFxAXJPTpIpqI0ll6Psym"  -->