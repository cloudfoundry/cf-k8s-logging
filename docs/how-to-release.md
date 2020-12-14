Note that cf-k8s-logging does NOT use a develop->main workflow. Their PR workflow pushes changes to main as part of acceptance.

1. Make sure cf-k8s-logging `main` has what you need, including relevant versions of
    - Log-cache https://github.com/cloudfoundry/cf-k8s-logging/blob/5c0e089d23eedaa3d1b9fd717cc1f687b04e3adb/vendir.yml#L6-L9
    - fluentd https://github.com/cloudfoundry/cf-k8s-logging/blob/5c0e089d23eedaa3d1b9fd717cc1f687b04e3adb/vendir.yml#L10-L13
1. Head to the [cf-k8s-logging](https://release-integration.ci.cf-app.com/teams/main/pipelines/cf-k8s-logging-validation) pipeline and make sure the `run-tests-on-cf-for-k8s-main` job is green
1. Manually bump the release version in the pipeline yaml and re-fly
1. Trigger create-release
1. Commit and push your changes (eg bumping the release version in the pipeline)
1. Head to [cf-k8s-logging releases](https://github.com/cloudfoundry/cf-k8s-logging/releases) and edit the new draft release. Add relevant release notes and then publish the release.
