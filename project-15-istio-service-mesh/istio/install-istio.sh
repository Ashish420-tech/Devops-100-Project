#!/bin/bash

echo "Downloading Istio..."
curl -L https://istio.io/downloadIstio | sh

cd istio-*

export PATH=$PWD/bin:$PATH

echo "Installing Istio..."
istioctl install --set profile=demo -y

echo "Verifying Istio..."
kubectl get pods -n istio-system
