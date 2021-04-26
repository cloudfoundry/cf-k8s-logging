# cf-k8s-logging

## Purpose
This pipeline tests and releases components necessary for cf-k8s-logging including log-cache images and the fluentd plugin.

## Validation
The `run-tests-on-cf-for-k8s-pr` and `run-tests-on-cf-for-k8s-main` jobs do the following:
- builds all the log-cache and fluent images sourced in `vendir.yml`
- updates the image references in `config/values/images`
- bumps the reference to cf-k8s-logging in cf-for-k8s
- Runs the cf-for-k8s smoke tests
- Runs the logging integration tests in `hack/run_integration_tests.sh`

The pipeline configuration sets up a [YAML anchor](https://blog.betomorrow.com/yaml-tips-and-tricks-for-concourse-ci-35a3b577a239) to reuse these tasks.

The `run-tests-on-cf-for-k8s-pr` job in particular, watches for PRs and runs the changes against cf-for-k8s develop
branch. This will report back to the PR if the tests are successfully or not. The `run-tests-on-cf-for-k8s-main` job runs on the `main` branch.

## Release Process
This publishes a Github release with the config templates after re-running all the validation tests. It could be more efficient to change this to a passed constraint instead. The version is managed by a concourse semver resource and commited to the main branch.

### How to update dependencies
cf-k8s-logging requires images from [log-cache-release](https://github.com/cloudfoundry/log-cache-release/) and [cloudfoundy/fluent-plugin-syslog_rfc5424](https://github.com/cloudfoundry/fluent-plugin-syslog_rfc5424). To update these dependencies, update the refs in `vendir.yml`.

Each job in the pipeline runs the `hack/bump-cf-for-k8s.sh` to updates these dependencies.

## Fluent Plugin Syslog RFC5424
The following jobs are related to running Ruby tests on the [cloudfoundy/fluent-plugin-syslog_rfc5424](https://github.com/cloudfoundry/fluent-plugin-syslog_rfc5424) and releasing a new gem.

### test-ruby-plugin
This job runs `bundle exec rake test` to test the plugin.

### bump-gem-version
This job bumps the version of the gem's release candidate (i.e. 0.9.0.rc.7 see
[here](https://github.com/cloudfoundry/fluent-plugin-syslog_rfc5424/blob/8cb9d0af9b8d835b957c91f7ff3755bb29848baf/lib/fluent-plugin-syslog_rfc5424/version.rb#L2)).

#### release-gem
Builds a new gem and pushes it to https://rubygems.org/gems/fluent-plugin-syslog_rfc5424.
