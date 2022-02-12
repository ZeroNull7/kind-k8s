#!/bin/bash
set -o errexit

kind create cluster --config ./kindconfig.yaml

kubectl create namespace flux-system
kubectl create namespace infra 

gpg --export-secret-keys --armor "9DC11809DD7D102342B09932C40921F65EFEF866" | kubectl create secret generic sops-gpg --namespace=flux-system --from-file=sops.asc=/dev/stdin
gpg --export-secret-keys --armor "9DC11809DD7D102342B09932C40921F65EFEF866" | kubectl create secret generic sops-gpg --namespace=infra --from-file=sops.asc=/dev/stdin

kubectl apply -f kube-router.yaml

#flux bootstrap github \
#  --owner=ZeroNull7 \
#  --repository=kind-k8s \
#  --path=k8s \
#  --branch=main \
#  --cluster-domain dev.local \
#  --personal
