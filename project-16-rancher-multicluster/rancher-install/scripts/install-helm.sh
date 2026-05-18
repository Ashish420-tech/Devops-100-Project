#!/bin/bash

set -e

echo "========================================="
echo "Installing Helm"
echo "========================================="

curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

helm version

echo "========================================="
echo "Helm Installed Successfully"
echo "========================================="
