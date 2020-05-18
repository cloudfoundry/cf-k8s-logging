# Install Loki and Grafana
1. Dependencies
    - helm repo add stable https://kubernetes-charts.storage.googleapis.com/
    - helm repo add loki https://grafana.github.io/loki/charts
    - helm repo update

1. Loki
    - helm install loki loki/loki --namespace cf-system --set loki.persistence.enabled=true,loki.persistence.size=100Gi

1. Grafana
    - helm install loki-grafana stable/grafana --namespace cf-system

1. Expose Services
    - kubectl apply -f loki-virtualservice.yaml

1. Configure grafana to point to Loki
    - get password with `grafana_password.sh`
    - Go to loki-grafana.<system_domain>
    - login with admin/<password-from-above>
    - Setup datasource for loki
        - URL: https://loki.<system_domain>
        - Skip TLS verify
        - Save and test

1. Add plugin to fluent gemfile
1. Add loki to fluent outputs
1. build logging images
1. bump cf for k8s
1. install cf-for-k8s
1. View logs in grafana: {cloudfoundry_org_app_guid="dafdacb7-a73c-4eee-a50b-d700427b3257"}
1. install logcli
1. tail logs
    - logcli --addr=http://loki.<system_domain> query '{cloudfoundry_org_app_guid="dafdacb7-a73c-4eee-a50b-d700427b3257"}' -t
    - logcli --addr=http://loki.<system_domain> labels
