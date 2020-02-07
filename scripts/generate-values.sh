#!/usr/bin/env bash

set -eu
## Usage: ./generate-values.sh <my-domain>
## where my-domain will be used as both the system domain and app domain.

# Make sure bosh binary exists
bosh --version >/dev/null

VARS_FILE=/tmp/log-cache-vars.yaml
DOMAIN=$1

bosh interpolate --vars-store=${VARS_FILE} <(cat <<EOF
variables:
- name: log_cache_ca
  type: certificate
  options:
    is_ca: true
    common_name: log-cache-ca

- name: log_cache
  type: certificate
  options:
    ca: log_cache_ca
    common_name: log-cache
    extended_key_usage:
    - client_auth
    - server_auth

- name: log_cache_syslog
  type: certificate
  options:
    ca: log_cache_ca
    common_name: log-cache-syslog
    extended_key_usage:
    - client_auth
    - server_auth

- name: log_cache_metrics
  type: certificate
  options:
    ca: log_cache_ca
    common_name: log-cache-metrics
    extended_key_usage:
    - client_auth
    - server_auth

- name: log_cache_gateway
  type: certificate
  options:
    ca: log_cache_ca
    common_name: log-cache-gateway
    extended_key_usage:
    - client_auth
    - server_auth
EOF
) >/dev/null

cat <<EOF
#@data/values
---
system_domain: "${DOMAIN}"
system_namespace: cf-system

images:
  log_cache: logcache/log-cache
  syslog_server: logcache/syslog-server
  log_cache_gateway: logcache/log-cache-gateway
  fluent: logcache/cf-k8s-logging

log_cache_ca:
  crt: $( bosh interpolate ${VARS_FILE} --path=/log_cache_ca/certificate | base64 | tr -d '\n' )
  key: $( bosh interpolate ${VARS_FILE} --path=/log_cache_ca/private_key | base64 | tr -d '\n' )

log_cache:
  crt: $( bosh interpolate ${VARS_FILE} --path=/log_cache/certificate | base64 | tr -d '\n' )
  key: $( bosh interpolate ${VARS_FILE} --path=/log_cache/private_key | base64 | tr -d '\n' )

log_cache_metrics:
  crt: $( bosh interpolate ${VARS_FILE} --path=/log_cache_metrics/certificate | base64 | tr -d '\n' )
  key: $( bosh interpolate ${VARS_FILE} --path=/log_cache_metrics/private_key | base64 | tr -d '\n' )

log_cache_gateway:
  crt: $( bosh interpolate ${VARS_FILE} --path=/log_cache_gateway/certificate | base64 | tr -d '\n' )
  key: $( bosh interpolate ${VARS_FILE} --path=/log_cache_gateway/private_key | base64 | tr -d '\n' )

log_cache_syslog:
  crt: $( bosh interpolate ${VARS_FILE} --path=/log_cache_syslog/certificate | base64 | tr -d '\n' )
  key: $( bosh interpolate ${VARS_FILE} --path=/log_cache_syslog/private_key | base64 | tr -d '\n' )

EOF