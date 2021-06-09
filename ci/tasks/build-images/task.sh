#!/bin/bash
set -euo pipefail

trap "pkill dockerd" EXIT

start-docker &
echo 'until docker info; do sleep 5; done' >/usr/local/bin/wait_for_docker
chmod +x /usr/local/bin/wait_for_docker
timeout 300 wait_for_docker

<<<"$DOCKERHUB_PASSWORD" docker login --username "$DOCKERHUB_USERNAME" --password-stdin

pushd cf-k8s-logging-main > /dev/null
    ./build/build.sh ${COMPONENT}
popd > /dev/null

mkdir -p kbld-lock-files/${COMPONENT}
cp cf-k8s-logging-main/build/${COMPONENT}/kbld.lock.yml kbld-lock-files/${COMPONENT}/kbld.lock.yml 
