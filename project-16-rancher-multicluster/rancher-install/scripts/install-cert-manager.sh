#!/bin/bash

set -e

echo "========================================="
echo "Installing cert-manager"
echo "========================================="

helm repo add jetstack https://charts.jetstack.io
helm repo update

kubectl create namespace cert-manager || true

helm install cert-manager jetstack/cert-manager \
  --namespace cert-manager \
  --set installCRDs=true

echo "Verifying cert-manager pods..."

kubectl get pods -n cert-manager

echo "========================================="
echo "cert-manager Installed Successfully"
echo "========================================="
