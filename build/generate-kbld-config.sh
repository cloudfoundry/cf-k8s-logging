#! /bin/bash

set -euo pipefail

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

function generate_logging_kbld_config() {
  local kbld_config_path="${1}"
  local image_name="${2}"

  local source_path
  source_path="${SCRIPT_DIR}/.."

  pushd "${source_path}" > /dev/null
    local git_ref
    git_ref=$(git rev-parse HEAD)
  popd > /dev/null

  echo "Creating logging kbld config with ytt..."
  local kbld_config_values
  kbld_config_values=$(cat <<EOF
#@data/values
---
git_ref: ${git_ref}
git_url: https://github.com/cloudfoundry/cf-k8s-logging
EOF
)

  echo "${kbld_config_values}" | ytt -f "${SCRIPT_DIR}/${image_name}/kbld.yml" -f - > "${kbld_config_path}"
}

function generate_gateway_kbld_config() {
  local kbld_config_path="${1}"
  local image_name="${2}"

  local source_path
  source_path="${SCRIPT_DIR}/.."

  pushd "${source_path}" > /dev/null
    local git_ref
    git_ref=$(git rev-parse HEAD)
  popd > /dev/null

  local version
  version=$(cat ${SCRIPT_DIR}/../vendor/log-cache/src/version)
  echo "VERSION IS: ${version}"
  echo "****************************************************"

  echo "Creating logging kbld config with ytt..."
  local kbld_config_values
  kbld_config_values=$(cat <<EOF
#@data/values
---
git_ref: ${git_ref}
git_url: https://github.com/cloudfoundry/cf-k8s-logging
version:  ${version}
EOF
)

  echo "${kbld_config_values}" | ytt -f "${SCRIPT_DIR}/${image_name}/kbld.yml" -f - > "${kbld_config_path}"
}

function generate_fluent_bit_kbld_config() {
  local kbld_config_path="${1}"

  local source_path
  source_path="${SCRIPT_DIR}/../vendor/cf-k8s-logging-fluent"

  pushd "${source_path}" > /dev/null
    local git_ref
    git_ref="v$(grep FLB_VERSION fluent-bit/Dockerfile | cut -d ' ' -f 3 | head -n 1)"
  popd > /dev/null

  echo "Creating fluentbit kbld config with ytt..."
  local kbld_config_values
  kbld_config_values=$(cat <<EOF
#@data/values
---
git_ref: ${git_ref}
git_url: https://github.com/fluent/fluent-bit
EOF
)

  echo "${kbld_config_values}" | ytt -f "${SCRIPT_DIR}/${image_name}/kbld.yml" -f - > "${kbld_config_path}"
}

function generate_kbld_config() {
  case "$2" in
    fluent-bit)
      echo "Generating fluent bit config" 
      generate_fluent_bit_kbld_config "$@"
      ;;
    log-cache-gateway)
      echo "Generating log cache gateway config"
      generate_gateway_kbld_config "$@"
      ;;
    *)
      echo "Generating logging config"
      generate_logging_kbld_config "$@"
      ;;
  esac
}

function main() {
  local kbld_config_path="${1}"
  local image_name="${2}"

  generate_kbld_config "${kbld_config_path}" "${image_name}"
}

main "$@"
