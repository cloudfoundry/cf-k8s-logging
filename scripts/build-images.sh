REPOSITORY=${REPOSITORY:-logcache}
docker build -t $REPOSITORY/log-cache:latest vendor/log-cache/src -f vendor/log-cache/src/cmd/log-cache/Dockerfile
docker build -t $REPOSITORY/log-cache-gateway:latest vendor/log-cache/src -f vendor/log-cache/src/cmd/gateway/Dockerfile
docker build -t $REPOSITORY/log-cache-cf-auth-proxy:latest vendor/log-cache/src -f vendor/log-cache/src/cmd/cf-auth-proxy/Dockerfile
docker build -t $REPOSITORY/syslog-server:latest vendor/log-cache/src -f vendor/log-cache/src/cmd/syslog-server/Dockerfile
docker build -t $REPOSITORY/cf-k8s-logging:latest vendor/cf-k8s-logging-fluent

docker push $REPOSITORY/log-cache:latest
docker push $REPOSITORY/log-cache-gateway:latest
docker push $REPOSITORY/log-cache-cf-auth-proxy:latest
docker push $REPOSITORY/syslog-server:latest
docker push $REPOSITORY/cf-k8s-logging:latest

syslog_digest=$(docker image inspect $REPOSITORY/syslog-server:latest --format {{.Id}})
log_cache_digest=$(docker image inspect $REPOSITORY/log-cache:latest --format {{.Id}})
log_cache_gateway_digest=$(docker image inspect $REPOSITORY/log-cache-gateway:latest --format {{.Id}})
cf_auth_proxy_digest=$(docker image inspect $REPOSITORY/log-cache-cf-auth-proxy:latest --format {{.Id}})
cf_k8s_logging_digest=$(docker image inspect $REPOSITORY/cf-k8s-logging:latest --format {{.Id}})

#set the digests
sed -i '' -e "s| syslog_server:.*| syslog_server: \"$REPOSITORY/syslog-server@$syslog_digest\"|" config/values.yml
sed -i '' -e "s| log_cache:.*| log_cache: \"$REPOSITORY/log-cache@$log_cache_digest\"|" config/values.yml
sed -i '' -e "s| log_cache_gateway:.*| log_cache_gateway: \"$REPOSITORY/log-cache-gateway@$log_cache_gateway_digest\"|" config/values.yml
sed -i '' -e "s| cf_auth_proxy:.*| cf_auth_proxy: \"$REPOSITORY/log-cache-cf-auth-proxy@$cf_auth_proxy_digest\"|" config/values.yml
sed -i '' -e "s| fluent:.*| fluent: \"$REPOSITORY/cf-k8s-logging@$cf_k8s_logging_digest\"|" config/values.yml
