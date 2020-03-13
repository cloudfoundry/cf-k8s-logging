#!/usr/bin/env bash

set -ex

CF_FOR_K8s_DIR="${CF_FOR_K8s_DIR:-${HOME}/workspace/cf-for-k8s/}"
SCRIPT_DIR="$(cd $(dirname $0) && pwd -P)"
BASE_DIR="${SCRIPT_DIR}/.."

pushd "${CF_FOR_K8s_DIR}"
  vendir sync -d config/_ytt_lib/github.com/cloudfoundry/cf-k8s-logging="${BASE_DIR}"
popd

# this is here until cf-for-k8s removes pinned images
sed -i'' -e "/ syslog_server: .*/d" $CF_FOR_K8s_DIR/config/values.yml
sed -i'' -e "/ log_cache_gateway: .*/d" $CF_FOR_K8s_DIR/config/values.yml
sed -i'' -e "/ fluent: .*/d" $CF_FOR_K8s_DIR/config/values.yml
sed -i'' -e "/ log_cache: .*/d" $CF_FOR_K8s_DIR/config/values.yml

sed -i'' -e "/images:/d" $CF_FOR_K8s_DIR/config/logging.yml
sed -i'' -e "/ log_cache:/d" $CF_FOR_K8s_DIR/config/logging.yml
sed -i'' -e "/ log_cache_gateway:/d" $CF_FOR_K8s_DIR/config/logging.yml
sed -i'' -e "/ syslog_server:/d" $CF_FOR_K8s_DIR/config/logging.yml
sed -i'' -e "/ fluent:/d" $CF_FOR_K8s_DIR/config/logging.yml
