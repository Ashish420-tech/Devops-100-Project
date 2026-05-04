🚀 Project 13: Kubernetes Persistent Storage with AWS EBS (EKS)


================================================================================================
📌 Overview

Implemented dynamic persistent storage in Kubernetes using AWS EBS CSI driver on EKS, including volume expansion, snapshot, and restore.

🧱 Architecture


PVC → StorageClass → EBS Volume → Pod
              ↓
        VolumeSnapshot
              ↓
        Restore PVC → New Pod


⚙️ Setup Steps

1. Create EKS Cluster
bash scripts/eks-setup.sh

2. Enable OIDC
eksctl utils associate-iam-oidc-provider \
  --region ap-south-1 \
  --cluster devops-eks-cluster \
  --approve


3. Install EBS CSI Driver
eksctl create iamserviceaccount \
  --name ebs-csi-controller-sa \
  --namespace kube-system \
  --cluster devops-eks-cluster \
  --attach-policy-arn arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy \
  --approve \
  --role-name AmazonEKS_EBS_CSI_DriverRole

eksctl create addon \
  --name aws-ebs-csi-driver \
  --cluster devops-eks-cluster \
  --service-account-role-arn arn:aws:iam::<ACCOUNT-ID>:role/AmazonEKS_EBS_CSI_DriverRole \
  --force


📦 Storage Setup


kubectl apply -f manifests/storageclass.yaml
kubectl apply -f manifests/pvc.yaml
kubectl apply -f manifests/deployment.yaml

🔍 Validation


kubectl get pvc
kubectl get pv
kubectl exec -it <pod> -- df -h


🔄 Volume Expansion


kubectl edit pvc ebs-pvc

Change:

20Gi → 30Gi


📸 Snapshot Setup


kubectl apply -f snapshot CRDs
kubectl apply -f manifests/snapshot-class.yaml
kubectl apply -f manifests/snapshot.yaml

♻️ Restore Volume

kubectl apply -f manifests/restore-pvc.yaml
kubectl run restore-test ...

🧠 Key Learnings

Dynamic provisioning with EBS CSI

Volume expansion without downtime
Snapshot & restore workflow
Handling WaitForFirstConsumer scheduling
CRDs and controllers in Kubernetes
