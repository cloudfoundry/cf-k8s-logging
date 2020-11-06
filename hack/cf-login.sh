#!/bin/bash

CF_CLI=${CF_CLI:-cf7} # or cf

zone_name=${1:-sloans-lake}
cf_domain="${zone_name}.loggr.cf-app.com"

cf_admin_password="$(cat /tmp/${zone_name}.yml | yq r - cf_admin_password)"

echo "Targeting cf on ${zone_name}"

$CF_CLI api --skip-ssl-validation https://api.${cf_domain}
$CF_CLI auth admin ${cf_admin_password}
$CF_CLI create-org test-org
$CF_CLI create-space -o test-org test-space
$CF_CLI target -o test-org -s test-space
$CF_CLI enable-feature-flag diego_docker
