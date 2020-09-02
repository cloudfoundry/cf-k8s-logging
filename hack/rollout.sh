
#!/usr/bin/env bash

set -ex

export CF_FOR_K8s_DIR="${CF_FOR_K8s_DIR:-${HOME}/workspace/cf-for-k8s/}"
export SCRIPT_DIR="$(cd $(dirname $0) && pwd -P)"
export BASE_DIR="${SCRIPT_DIR}/.."

$SCRIPT_DIR/../scripts/bump-cf-for-k8s.sh
pushd "${CF_FOR_K8s_DIR}"
  ytt -f config -f /tmp/cf.yml > /tmp/cf-rendered.yml
  kapp deploy -a cf -f /tmp/cf-rendered.yml
popd

