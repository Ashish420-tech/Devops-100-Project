#!/bin/bash

set -e

echo "========================================="
echo "Installing Rancher"
echo "========================================="

helm repo add rancher-latest https://releases.rancher.com/server-charts/latest
helm repo update

kubectl create namespace cattle-system || true

helm install rancher rancher-latest/rancher \
  --namespace cattle-system \
  --set hostname=rancher.local \
  --set bootstrapPassword=admin123 \
  --set replicas=1

echo "Checking Rancher Deployment..."

kubectl rollout status deploy/rancher -n cattle-system

echo "========================================="
echo "Rancher Installed Successfully"
echo "========================================="
