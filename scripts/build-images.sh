#!/bin/bash

REPOSITORY=${REPOSITORY:-cloudfoundry}

function buildAndReplaceImage {
    image=$1
    srcFolder=$2
    dockerfile=$3
    yttValuesRef=$4

    docker build -t $REPOSITORY/$image:latest $srcFolder -f $srcFolder/$dockerfile --label "org.opencontainers.image.source=https://github.com/cloudfoundry/cf-k8s-logging.git" --label "org.opencontainers.image.revision=$(git rev-parse HEAD)"

    docker push $REPOSITORY/$image:latest

    imageRef="$(docker image inspect $REPOSITORY/$image:latest --format '{{index .RepoDigests 0}}')"
    sed -i'' -e "s| $yttValuesRef:.*| $yttValuesRef: \"$imageRef\"|" config/values/images.yml
}
buildAndReplaceImage log-cache vendor/log-cache/src cmd/log-cache/Dockerfile log_cache > /tmp/logcache.txt  &
buildAndReplaceImage log-cache-gateway vendor/log-cache/src cmd/gateway/Dockerfile log_cache_gateway > /tmp/log-cache-gateway.txt &
buildAndReplaceImage log-cache-cf-auth-proxy vendor/log-cache/src cmd/cf-auth-proxy/Dockerfile cf_auth_proxy > /tmp/auth-proxy.txt &
buildAndReplaceImage syslog-server vendor/log-cache/src cmd/syslog-server/Dockerfile syslog_server > /tmp/syslog-server.txt &
buildAndReplaceImage cf-k8s-logging vendor/cf-k8s-logging-fluent/fluentd Dockerfile fluent > /tmp/fluent.txt &

wait
