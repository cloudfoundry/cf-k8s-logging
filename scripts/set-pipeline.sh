#!/bin/bash
fly -t denver set-pipeline -p cf-k8s-logging -c ./ci/cf-k8s-logging-validation.yml \
-l <(lpass show 'Shared-Loggregator (Pivotal Only)/pipeline-secrets.yml' --notes) \
-l <(lpass show 'Shared-CF- Log Cache (Pivotal ONLY)/release-credentials.yml' --notes) \
-l <(lpass show 'Shared Pivotal Common/pas-releng-fetch-releases' --notes) \
-l <(lpass show 'Shared-Loggregator (Pivotal Only)/cf-k8s-logging-pipeline-secrets.yml' --notes)
