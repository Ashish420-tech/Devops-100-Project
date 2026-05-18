# 🚀 Project 14: EKS Cluster with Terraform + AWS EBS Persistent Storage

## 📌 Overview

This project demonstrates provisioning a **production-ready Kubernetes cluster on AWS (EKS) using Terraform**, followed by implementing **persistent storage using AWS EBS CSI driver**, including:

* Dynamic volume provisioning
* Volume expansion
* Snapshot backup
* Restore workflow

👉 Built with a **declarative Infrastructure-as-Code approach (Terraform)** instead of manual provisioning.

---

## 🧱 Architecture

```
Terraform → VPC → EKS Cluster → Node Group
                          ↓
                  EBS CSI Driver
                          ↓
PVC → StorageClass → EBS Volume → Pod
                          ↓
                 VolumeSnapshot
                          ↓
              Restore PVC → New Pod
```

---

## ⚙️ Tech Stack

* Terraform (Infrastructure as Code)
* AWS EKS (Managed Kubernetes)
* AWS VPC (Networking)
* AWS EBS (Persistent Storage)
* Kubernetes (PVC, StorageClass, VolumeSnapshot)
* IAM + OIDC (IRSA)

---

## 📁 Project Structure

```
project-14-eks-terraform-ebs/
├── main.tf
├── provider.tf
├── variables.tf
├── outputs.tf
├── terraform.tfvars
├── manifests/
│   ├── storageclass.yaml
│   ├── pvc.yaml
│   ├── deployment.yaml
│   ├── snapshot-class.yaml
│   ├── snapshot.yaml
│   ├── restore-pvc.yaml
├── scripts/
└── README.md
```

---

## 🚀 Step-by-Step Execution

### 1️⃣ Initialize Terraform

```bash
terraform init
```

---

### 2️⃣ Validate Configuration

```bash
terraform validate
```

---

### 3️⃣ Plan Infrastructure

```bash
terraform plan
```

---

### 4️⃣ Create EKS Cluster

```bash
terraform apply
```

⏳ Takes ~10–15 minutes

---

### 5️⃣ Configure kubectl

```bash
aws eks update-kubeconfig \
  --region ap-south-1 \
  --name devops-eks-cluster
```

---

### 6️⃣ Verify Cluster

```bash
kubectl get nodes
```

---

## 📦 Kubernetes Storage Setup

### Apply Storage Resources

```bash
kubectl apply -f manifests/storageclass.yaml
kubectl apply -f manifests/pvc.yaml
kubectl apply -f manifests/deployment.yaml
```

---

## 🔍 Validation

```bash
kubectl get pvc
kubectl get pv
kubectl get pods
kubectl exec -it <pod-name> -- df -h
```

✔️ Confirms EBS volume is mounted inside container

---

## 🔄 Volume Expansion

```bash
kubectl edit pvc ebs-pvc
```

Update:

```
20Gi → 30Gi
```

---

## 📸 Snapshot & Restore

### Install Snapshot CRDs (if needed)

```bash
kubectl apply -f https://raw.githubusercontent.com/kubernetes-csi/external-snapshotter/master/client/config/crd/...
```

---

### Create Snapshot

```bash
kubectl apply -f manifests/snapshot.yaml
kubectl get volumesnapshot
```

---

### Restore PVC

```bash
kubectl apply -f manifests/restore-pvc.yaml
```

---

### Validate Restore

```bash
kubectl run restore-test ...
kubectl exec -it restore-test -- df -h
```

---

## 🧠 Key Learnings

* Terraform-based EKS provisioning
* Difference between imperative vs declarative infrastructure
* IRSA (IAM Roles for Service Accounts)
* Kubernetes dynamic storage provisioning
* Volume expansion without downtime
* Snapshot-based backup and recovery
* Debugging PVC Pending & scheduling issues

---

## 🚨 Challenges Faced

* Wrong Kubernetes context (minikube vs EKS)
* Missing VolumeSnapshot CRDs
* PVC stuck in Pending (WaitForFirstConsumer)
* Snapshot readiness delays
* Restore PVC scheduling deadlock

---

## 💡 Solutions Applied

* Enabled OIDC for IAM integration
* Installed snapshot CRDs manually
* Used node selection to break scheduling deadlock
* Validated storage using `df -h` inside pod

---

## 🎯 Why This Project Matters

This project demonstrates:

* Real-world Kubernetes storage lifecycle
* AWS + Kubernetes integration
* Infrastructure as Code (Terraform)
* Disaster recovery design

👉 Directly relevant for:

* DevOps Engineer
* Cloud Engineer
* SRE roles

---

## 🔥 Future Improvements

* Add Helm-based deployment
* Integrate monitoring (Prometheus + Grafana)
* Use Terraform modules for reusability
* Automate CI/CD pipeline

---

## 🧹 Cleanup

```bash
terraform destroy
```

---

## 💬 Author

Ashish Mondal
DevOps Engineer | Kubernetes | AWS | Terraform

---

## ⭐ If you found this useful

Give this repo a ⭐ and connect with me on LinkedIn!
