#! /usr/bin/env bash

set -ex

echo "Creating K8s Secrets"
ROOT_DIR=$(dirname "$0")/..
kubectl create secret tls -n pas-system log-cache-ca --key $ROOT_DIR/out/LogsEgressCA.key --cert $ROOT_DIR/out/LogsEgressCA.crt
kubectl create secret tls -n pas-system log-cache-metrics --key $ROOT_DIR/out/log-cache-metrics.key --cert $ROOT_DIR/out/log-cache-metrics.crt
kubectl create secret tls -n pas-system log-cache --key $ROOT_DIR/out/log-cache.key --cert $ROOT_DIR/out/log-cache.crt
kubectl create secret tls -n pas-system log-cache-gateway --key $ROOT_DIR/out/log-cache-gateway.key --cert $ROOT_DIR/out/log-cache-gateway.crt
kubectl create secret tls -n pas-system log-cache-syslog --key $ROOT_DIR/out/log-cache-syslog.key --cert $ROOT_DIR/out/log-cache-syslog.crt