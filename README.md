# cf-k8s-logging

### Requirements
An existing CF for k8s environment with a `system_domain`.

### Installation

1. `scripts/generate-values.sh <system_domain> > /tmp/values.yml`
1. `cd manifests && ytt -f . -f /tmp/values.yml > /tmp/logging-deploy.yml`
1. `kapp -a cf-k8s-logging -f /tmp/logging-deploy.yml`
1. See the logs from your CF pushed apps:
`curl -k https://log-cache.<system_domain>/api/v1/read/<app-guid>`
