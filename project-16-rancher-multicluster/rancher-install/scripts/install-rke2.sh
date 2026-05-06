#!/bin/bash

set -e

echo "========================================="
echo "Installing RKE2 Kubernetes Cluster"
echo "========================================="

curl -sfL https://get.rke2.io | sh -

sudo systemctl enable rke2-server
sudo systemctl start rke2-server

echo "Waiting for cluster startup..."

sleep 30

export KUBECONFIG=/etc/rancher/rke2/rke2.yaml

echo "Cluster Nodes:"
sudo kubectl get nodes

echo "========================================="
echo "RKE2 Installation Completed"
echo "========================================="
