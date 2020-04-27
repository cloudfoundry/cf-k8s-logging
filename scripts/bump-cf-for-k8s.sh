#!/usr/bin/env bash

set -ex

CF_FOR_K8s_DIR="${CF_FOR_K8s_DIR:-${HOME}/workspace/cf-for-k8s/}"
SCRIPT_DIR="$(cd $(dirname $0) && pwd -P)"
BASE_DIR="${SCRIPT_DIR}/.."

pushd "${CF_FOR_K8s_DIR}"
  vendir sync -d config/_ytt_lib/github.com/cloudfoundry/cf-k8s-logging/config="${BASE_DIR}/config"

  sed -i '/^client:/,+2 d' config/logging.yml
  sed -i '/^log_cache_client:/,+3 d' config/values.yml

  sed -i '/^- name: log_cache_client_password/,+1 d' hack/generate-values.sh
  sed -i '/^log_cache_client:/,+3 d' hack/generate-values.sh

popd

