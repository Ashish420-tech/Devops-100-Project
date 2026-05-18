#!/bin/bash

# -----------------------------
# CONFIGURATION (you can change later)
# -----------------------------
CLUSTER_NAME=devops-eks-cluster
REGION=ap-south-1
NODE_TYPE=m7i-flex.large
NODE_COUNT=2

echo "🚀 Creating EKS Cluster: $CLUSTER_NAME"

# -----------------------------
# CREATE EKS CLUSTER
# -----------------------------
eksctl create cluster \
  --name $CLUSTER_NAME \
  --region $REGION \
  --nodegroup-name standard-workers \
  --node-type $NODE_TYPE \
  --nodes $NODE_COUNT \
  --nodes-min 1 \
  --nodes-max 3 \
  --managed \
  --with-oidc \
  --ssh-access \
  --ssh-public-key devops100 \
  --asg-access \
  --external-dns-access \
  --full-ecr-access \
  --appmesh-access \
  --alb-ingress-access

echo "✅ EKS Cluster Created Successfully!"
