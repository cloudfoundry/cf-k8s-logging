#!/usr/bin/env bash

# Env Variables
# PAS_WORKLOAD_NAMESPACE
# SYSLOG_HOST
# SYSLOG_PORT
# SYSLOG_PROTOCOL

set -euo pipefail

# deploy daemonset to environment
#     - https://github.com/fluent/fluentd-kubernetes-daemonset/blob/master/fluentd-daemonset-syslog.yaml



# for pks, also mount /var/vcap/store from https://github.com/pivotal-cf/sink-resources/blob/master/manifests/base/500-fluent-bit-daemon.yaml

#Also,
# - build image
# - upload image to dockerhub
