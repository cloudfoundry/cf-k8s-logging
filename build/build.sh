#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
KBLD_CONFIG_DIR="$(mktemp -d)"

function cleanup() {
  echo "Cleaning up..."
  rm -rf "${KBLD_CONFIG_DIR}"
}

trap cleanup EXIT

if [ "$#" -lt 1 ]; then
  echo "Error: You must provide at least one component directory to build"
  exit 1
fi

pushd "${SCRIPT_DIR}" > /dev/null
  components=( "$@" )
  # ensure input components are actually valid
  for component in "${components[@]}"; do
    if [ ! -d "${SCRIPT_DIR}/${component}" ]; then
      echo "Error: The following component directory does not exist: ${component}"
      echo "Usage: build.sh [component ...]"
      exit 1
    fi
  done

  # build each input component
  for component in "${components[@]}"; do
    KBLD_LOCK_FILE="${SCRIPT_DIR}/${component}/kbld.lock.yml"
    mkdir "${KBLD_CONFIG_DIR}/${component}"
    "${SCRIPT_DIR}/generate-kbld-config.sh" "${KBLD_CONFIG_DIR}/${component}/kbld.yml" "${component}"
    kbld -f "${KBLD_CONFIG_DIR}" -f "${SCRIPT_DIR}/${component}/image.yml" --lock-output "${KBLD_LOCK_FILE}"
  done

popd > /dev/null
