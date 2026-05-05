#!/bin/bash

echo "Enabling sidecar injection..."
kubectl label namespace default istio-injection=enabled --overwrite

echo "Deploying Bookinfo app..."
kubectl apply -f samples/bookinfo/platform/kube/bookinfo.yaml

echo "Applying Istio configs..."
kubectl apply -f manifests/

echo "Getting ingress IP..."
kubectl get svc istio-ingressgateway -n istio-system
