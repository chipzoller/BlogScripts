#!/bin/bash

### Assumptions made by this script:
### Only the images needed for a Kubernetes 1.18.4 deployment.
### The CRI is Docker
### You already have logged into your registry and any necessary certs saved locally to establish trust.
### The system from which this script is executed has pull access to the source registry and the push access to the target.
### You know better than to run this ugly script in production.

SOURCE_REGISTRY="k8s.gcr.io"
IMAGES="kube-proxy:v1.18.4
kube-scheduler:v1.18.4
kube-apiserver:v1.18.4
kube-controller-manager:v1.18.4
pause:3.2
coredns:1.6.7
etcd:3.4.3-0"
TARGET_REGISTRY="harbor.domain.com/library"
for image in $IMAGES; do docker pull "${SOURCE_REGISTRY}/${image}"; done
for image in $IMAGES; do docker tag "${SOURCE_REGISTRY}/${image}" "${TARGET_REGISTRY}/$image"; done
for image in $IMAGES; do docker push "${TARGET_REGISTRY}/$image"; done