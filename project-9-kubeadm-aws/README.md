# 🚀 Project 9: Production-Style Kubernetes Cluster on AWS (kubeadm + Terraform + Ansible)

---

## 📌 Overview

This project demonstrates how to build a **production-style Kubernetes cluster from scratch on AWS EC2** using:

* **Terraform** → Infrastructure provisioning
* **Ansible** → Node configuration & automation
* **kubeadm** → Kubernetes cluster bootstrap
* **Calico** → Container networking
* **AWS EC2** → Cloud infrastructure

Unlike managed services like EKS, this project gives **deep control and understanding of Kubernetes internals**, making it highly valuable for DevOps engineers.

---

## 🎯 Objective

Build a fully functional Kubernetes cluster with:

* 1 Control Plane (Master)
* 2 Worker Nodes
* Pod networking (Calico)
* Application deployment validation

---

## 🧠 Problem Statement

Managed Kubernetes hides complexity.

This project solves that by:

* Exposing real cluster setup steps
* Teaching kubeadm internals
* Demonstrating infra + config automation
* Showing real-world debugging scenarios

---

## 🏗️ Architecture

```
                 ┌────────────────────────┐
                 │       AWS Cloud        │
                 └─────────┬──────────────┘
                           │
         ┌─────────────────┼─────────────────┐
         │                 │                 │
┌────────▼────────┐ ┌──────▼────────┐ ┌──────▼────────┐
│   Master Node   │ │  Worker Node  │ │  Worker Node  │
│  (Control Plane)│ │     Node 1    │ │     Node 2    │
└────────┬────────┘ └──────┬────────┘ └──────┬────────┘
         │                 │                 │
         └────────────┬────┴────┬────────────┘
                      │         │
                 ┌────▼─────────▼────┐
                 │   Kubernetes API  │
                 └────────┬──────────┘
                          │
                  ┌───────▼────────┐
                  │   Calico CNI   │
                  └───────┬────────┘
                          │
                    ┌─────▼─────┐
                    │   Pods    │
                    └───────────┘
```

---

## ⚙️ Tech Stack

| Layer         | Tool                 |
| ------------- | -------------------- |
| Cloud         | AWS EC2              |
| IaC           | Terraform            |
| Config Mgmt   | Ansible              |
| Orchestration | Kubernetes (kubeadm) |
| Networking    | Calico               |
| OS            | Ubuntu 22.04         |

---

## 📁 Project Structure

```
project-9-kubeadm-aws/
│
├── terraform/
│   ├── main.tf
│   ├── variables.tf
│   └── outputs.tf
│
├── ansible/
│   ├── inventory.ini
│   └── setup.yml
│
└── README.md
```

---

# 🛠️ Step-by-Step Playbook

## 🔹 Step 1: Provision Infrastructure (Terraform)

```bash
cd terraform
terraform init
terraform apply
```

### ✔️ Creates:

* 1 Master EC2
* 2 Worker EC2
* Security Groups (SSH + NodePort)

---

## 🔹 Step 2: Configure Nodes (Ansible)

```bash
cd ../ansible
ansible-playbook -i inventory.ini setup.yml -b
```

### ✔️ Installs:

* containerd
* kubeadm, kubelet, kubectl
* Kernel configs
* Disables swap

---

## 🔹 Step 3: Initialize Kubernetes (Master)

```bash
ssh -i devops100.pem ubuntu@<MASTER_IP>

sudo kubeadm init \
  --pod-network-cidr=192.168.0.0/16 \
  --cri-socket unix:///run/containerd/containerd.sock
```

---

## 🔹 Step 4: Configure kubectl

```bash
mkdir -p $HOME/.kube
sudo cp /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
```

---

## 🔹 Step 5: Install Networking (Calico)

```bash
kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.26.1/manifests/calico.yaml
```

---

## 🔹 Step 6: Join Worker Nodes

```bash
sudo kubeadm join <MASTER_IP>:6443 --token <TOKEN> \
--discovery-token-ca-cert-hash sha256:<HASH>
```

---

## 🔹 Step 7: Verify Cluster

```bash
kubectl get nodes
```

✅ Expected:

```
master     Ready
worker-1   Ready
worker-2   Ready
```

---

## 🔹 Step 8: Deploy Test Application

```bash
kubectl create deployment nginx --image=nginx
kubectl expose deployment nginx --type=NodePort --port=80
```

---

## 🔹 Step 9: Access Application

```bash
kubectl get svc
```

Open:

```
http://<WORKER_IP>:<NODEPORT>
```

---

# 📊 Observations

| Feature              | Result |
| -------------------- | ------ |
| Cluster provisioning | ✅      |
| Networking (Calico)  | ✅      |
| Pod scheduling       | ✅      |
| Service exposure     | ✅      |

---

# ⚠️ Common Issues & Fixes

### ❌ Node NotReady

✔ Fix: Install CNI (Calico)

---

### ❌ kubeadm join error

✔ Fix:

```bash
sudo kubeadm reset -f
```

---

### ❌ Port not accessible

✔ Fix: Open Security Group NodePort range (30000–32767)

---

# 🧠 Key Learnings

* kubeadm gives full cluster control
* Kubernetes requires CNI for readiness
* Infrastructure + configuration separation is critical
* Debugging cluster issues is a core DevOps skill

---

# 🚀 Real-World Relevance

This architecture mirrors:

* Self-managed Kubernetes clusters
* On-prem production setups
* Hybrid cloud deployments

---

# 🔐 Production Considerations

* Use LoadBalancer / Ingress (not NodePort)
* Implement IAM roles (IRSA)
* Add monitoring (Prometheus + Grafana)
* Enable logging (ELK stack)
* Use Terraform modules

---

# 💡 Next Steps

* Kubernetes Ingress (Project 10)
* Helm package manager
* CI/CD pipelines
* Observability stack

---

# 🏁 Conclusion

This project demonstrates a **complete Kubernetes cluster lifecycle**:

* Infrastructure provisioning
* Configuration automation
* Cluster initialization
* Networking setup
* Application deployment

It showcases **real-world DevOps capabilities**, making it highly valuable for recruiters and production environments.

---

# ⚠️ Cleanup (Avoid AWS Charges)

```bash
cd terraform
terraform destroy
```

---

# 👨‍💻 Author

Ashish Mondal
DevOps Engineer | Kubernetes | Cloud | Automation

---
