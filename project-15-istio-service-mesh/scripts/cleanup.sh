#!/bin/bash

echo "Deleting Bookinfo..."
kubectl delete -f samples/bookinfo/platform/kube/bookinfo.yaml

echo "Deleting Istio configs..."
kubectl delete -f manifests/

