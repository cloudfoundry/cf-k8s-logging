#! /usr/bin/env bash

set -ex

echo "Creating certs"

certstrap init --common-name "LogsEgressCA" --passphrase "" --expires "2 years"

certstrap request-cert --common-name "log-cache" --passphrase ""
certstrap sign "log-cache" --CA "LogsEgressCA" --passphrase ""

certstrap request-cert --common-name "log-cache-metrics" --passphrase ""
certstrap sign "log-cache-metrics" --CA "LogsEgressCA" --passphrase ""

certstrap request-cert --common-name "log-cache-gateway" --passphrase ""
certstrap sign "log-cache-gateway" --CA "LogsEgressCA" --passphrase ""

certstrap request-cert --common-name "log-cache-syslog" --passphrase ""
certstrap sign "log-cache-syslog" --CA "LogsEgressCA" --passphrase ""


