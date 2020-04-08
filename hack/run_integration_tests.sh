#!/usr/bin/env sh

set -eu

cd "`dirname $0`/../tests/integration"
ginkgo -v -r ./

