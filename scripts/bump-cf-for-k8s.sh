#!/usr/bin/env bash

set -ex

CF_FOR_K8s_DIR="${CF_FOR_K8s_DIR:-${HOME}/workspace/cf-for-k8s/}"
SCRIPT_DIR="$(cd $(dirname $0) && pwd -P)"
BASE_DIR="${SCRIPT_DIR}/.."

pushd "${CF_FOR_K8s_DIR}"
  vendir sync -d config/logging/_ytt_lib/cf-k8s-logging="${BASE_DIR}/config"

  #remove after upstreaming removal of certs
  sed -i '/^log_cache_metrics:/,+3 d' config/logging/logging.yml
popd

