# Project 11: Kubernetes Network Policies (Zero Trust Networking)

## 📌 Overview

This project demonstrates implementation of **zero-trust networking** in Kubernetes using NetworkPolicies.

By default, Kubernetes allows all pod-to-pod communication. This project enforces strict security by allowing only required traffic.

---

## 🛠️ Tools & Technologies

- Kubernetes
- Calico (CNI)
- NetworkPolicy
- kubectl

---

## 🏗️ Architecture

Namespaces:
- frontend
- backend

Traffic Flow:
- frontend → backend ✅ allowed
- backend → mysql ✅ allowed (restricted)
- all other traffic ❌ blocked

---

## 📂 Project Structure


project-11-k8s-network-policies/
├── namespaces/
├── deployments/
├── services/
├── network-policies/
├── tests/
└── README.md


---

## 🚀 Implementation Steps

### 1. Setup Cluster with Calico

```bash
minikube start --cni=calico
2. Deploy Applications
kubectl apply -f namespaces/
kubectl apply -f deployments/
kubectl apply -f services/
3. Apply Default Deny
kubectl apply -f network-policies/default-deny.yaml
4. Allow Required Traffic
kubectl apply -f network-policies/allow-frontend-to-backend.yaml
kubectl apply -f network-policies/allow-backend-to-db.yaml
kubectl apply -f network-policies/allow-dns.yaml
kubectl apply -f network-policies/allow-ingress.yaml
🧪 Validation
✅ Allowed
kubectl exec -n frontend <pod> -- wget -qO- backend-svc.backend
❌ Blocked
kubectl exec -n test-ns test-pod -- wget backend-svc.backend
🔐 Key Concepts
Default deny (zero trust)
Namespace isolation
PodSelector & NamespaceSelector
Ingress & Egress control
DNS allowance for service discovery
🚨 Challenges Faced
NetworkPolicy not working due to missing CNI
Fixed by enabling Calico in Minikube
🎯 Outcome

Achieved a zero-trust Kubernetes network where only explicitly allowed traffic is permitted.

📌 Key Learning

Kubernetes networking is open by default, and security must be enforced explicitly using NetworkPolicies.
