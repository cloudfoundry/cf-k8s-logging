# cf-k8s-logging

cf-k8s-logging contains the portions of cf-for-k8s which enable logging
outcomes.

### Development flow

1. make updates needed (update vendir, update k8s files, etc).
1. make local commit(should make reverting image tags easy)
1. run build ./scripts/build-images.sh, setting $REPOSITORY to a docker
   repository you can push to
1. run ./scripts/bump-cf-for-k8s.sh
1. follow cf-for-k8s deployment steps.

