#!/bin/bash

CLUSTER=${1}

kubectl config use-context docker-desktop
kubectl config delete-user "${CLUSTER}"
kubectl config delete-cluster "${CLUSTER}"
kubectl config delete-context "${CLUSTER}"

cp ~/.kube/config ~/.kube/config.bak && \
    KUBECONFIG=~/.kube/config:${HOME}/github/beantown/infrastructure/kube kubectl config view --flatten > /tmp/config && \
    mv /tmp/config ~/.kube/config && \
    chmod 600 ~/.kube/config
