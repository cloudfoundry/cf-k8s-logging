#! /bin/bash


gcloud container clusters create $1 --zone=us-central1 \
    --no-enable-cloud-logging --no-enable-cloud-monitoring \
    --cluster-version=latest --node-version=latest --enable-autoupgrade \
    --num-nodes=1 --machine-type=n1-standard-4 --enable-autoscaling --min-nodes 1 --max-nodes=3 \
    --enable-network-policy
