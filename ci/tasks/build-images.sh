#!/bin/bash
set -euo pipefail

source "/opt/resource/common.sh"
start_docker 3 3 "" ""
log_in "$DOCKER_USERNAME" "$DOCKER_PASSWORD" ""

pushd cf-k8s-logging
    DEPLAB=true ./scripts/build-images.sh
popd
