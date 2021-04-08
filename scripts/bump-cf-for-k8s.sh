#!/usr/bin/env bash

set -ex

CF_FOR_K8s_DIR="${CF_FOR_K8s_DIR:-${HOME}/workspace/cf-for-k8s/}"
SCRIPT_DIR="$(cd $(dirname $0) && pwd -P)"
BASE_DIR="${SCRIPT_DIR}/.."

pushd "${CF_FOR_K8s_DIR}"
  vendir sync -d config/logging/_ytt_lib/cf-k8s-logging="${BASE_DIR}/config"
  cp -r "${BASE_DIR}"/tests/assets/aggregate-drain.yml config/logging/_ytt_lib/cf-k8s-logging/values/
  cp -r "${BASE_DIR}"/tests/assets/ncat-deploy.yml config/logging/_ytt_lib/cf-k8s-logging/
popd

