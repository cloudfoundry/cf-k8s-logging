fly set-pipeline -p cf-k8s-logging -t denver -c ./ci/cf-k8s-logging-validation.yml \
-l <(lpass show 'Shared-Loggregator (Pivotal Only)/pipeline-secrets.yml' --notes) \
-l <(lpass show 'Shared-CF- Log Cache (Pivotal ONLY)/release-credentials.yml' --notes) \
-l <(lpass show 'Shared-Pivotal Common/pas-releng-fetch-releases' --notes) \
-l <(lpass show 'Shared-Loggregator (Pivotal Only)/log-cache-gcp-service-account-key.json' --notes) \
-l <(cat ../deployments-loggregator/gcp/service-account.key.json) \
-v ci_k8s_gcp_project_name="cff-loggregator" \
-v ci_k8s_gcp_project_zone="us-central1" \
-v ci_k8s_gke_cluster_name="basenji"
