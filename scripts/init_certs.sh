#! /usr/bin/env bash

set -ex

echo "Creating certs"

certstrap init --common-name "LogsEgressCA" --passphrase "logsegress" --expires "2 years"

certstrap request-cert --common-name "log-cache" --passphrase "logsegress"
certstrap sign "log-cache" --CA "LogsEgressCA" --passphrase "logsegress"

certstrap request-cert --common-name "log-cache-metrics" --passphrase "logsegress"
certstrap sign "log-cache-metrics" --CA "LogsEgressCA" --passphrase "logsegress"

certstrap request-cert --common-name "log-cache-gateway" --passphrase "logsegress"
certstrap sign "log-cache-gateway" --CA "LogsEgressCA" --passphrase "logsegress"

certstrap request-cert --common-name "log-cache-syslog-server" --passphrase "logsegress"
certstrap sign "log-cache-syslog-server" --CA "LogsEgressCA" --passphrase "logsegress"

echo "Creating K8s Secrets"

kubectl 
