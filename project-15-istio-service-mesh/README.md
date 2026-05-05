# 🚀 Istio Service Mesh on AWS EKS (Project 15)

## 📌 Overview

This project demonstrates a **production-grade Service Mesh implementation using Istio on AWS EKS**, enabling:

* 🔐 Secure service-to-service communication (mTLS)
* 🔀 Intelligent traffic routing (Canary deployments)
* 📊 Full observability (Kiali, Jaeger, Grafana, Prometheus)
* ⚙️ Zero code changes to applications

---

## 🏗️ Architecture

```
User → AWS LoadBalancer → Istio Ingress Gateway
                          ↓
                   Envoy Sidecars
                          ↓
        productpage → reviews → ratings → details
                          ↓
        Kiali + Jaeger + Grafana + Prometheus
```

---

## 🛠️ Tech Stack

* Kubernetes (EKS)
* Istio (Service Mesh)
* AWS (EC2, ELB)
* Kiali (Service Graph)
* Jaeger (Distributed Tracing)
* Grafana + Prometheus (Metrics)
* kubectl, eksctl

---

## ⚙️ Implementation Steps

### 1. Create EKS Cluster

```bash
eksctl create cluster --name istio-cluster --region ap-south-1
```

---

### 2. Install Istio

```bash
istioctl install --set profile=demo -y
```

---

### 3. Enable Sidecar Injection

```bash
kubectl label namespace default istio-injection=enabled
```

---

### 4. Deploy Sample Application (Bookinfo)

```bash
kubectl apply -f samples/bookinfo/platform/kube/bookinfo.yaml
```

---

### 5. Configure Gateway & VirtualService

* Expose application externally via Istio Ingress Gateway
* Route traffic to `productpage`

---

### 6. Enable Traffic Splitting (Canary Deployment)

```yaml
VirtualService (reviews):
- v1 → 80%
- v2 → 20%
```

---

### 7. Enable mTLS (Zero Trust Security)

```yaml
PeerAuthentication:
  mtls:
    mode: STRICT
```

```yaml
DestinationRule:
  tls:
    mode: ISTIO_MUTUAL
```

---

### 8. Install Observability Stack

```bash
kubectl apply -f samples/addons
```

Includes:

* Kiali
* Jaeger
* Grafana
* Prometheus

---

## 📊 Observability

### 🔷 Kiali

* Service graph visualization
* Traffic flow between microservices

### 🔶 Jaeger

* End-to-end request tracing
* Latency breakdown per service

### 🔷 Grafana

* Request rate (RPS)
* Latency (P50, P90)
* Success rate
* mTLS verification

---

## 🔍 Key Features Demonstrated

### 🔐 mTLS Security

* Enforced STRICT mode
* All inter-service traffic encrypted

---

### 🔀 Traffic Management

* Canary deployment using weighted routing
* Controlled rollout between service versions

---

### 📊 Observability

* Real-time metrics monitoring
* Distributed tracing
* Service dependency visualization

---

### ⚙️ Troubleshooting Experience

Handled real-world issues:

* ❌ Pods stuck in Pending → Fixed via node scaling
* ❌ Missing sidecar injection → Fixed via namespace labeling
* ❌ mTLS breaking traffic → Fixed using DestinationRule
* ❌ Observability showing no data → Generated traffic load

---

## 🌐 Access Application

```bash
kubectl get svc istio-ingressgateway -n istio-system
```

Open:

```
http://<EXTERNAL-IP>/productpage
```

---

## 💬 Interview Highlights

* Implemented **service mesh architecture on EKS**
* Enabled **zero-trust security with mTLS**
* Configured **canary deployments using Istio routing**
* Built **full observability stack for microservices monitoring**
* Resolved **real-world production issues in Kubernetes & Istio**

---

## 🚀 Future Enhancements

* Infrastructure as Code (Terraform)
* CI/CD Pipeline Integration
* Autoscaling (HPA + Istio)
* Custom domain with HTTPS

---

## 📌 Conclusion

This project showcases **end-to-end service mesh implementation**, covering:

* Networking
* Security
* Observability
* Traffic management

👉 Equivalent to **real-world SRE / DevOps production systems**

---

## 👤 Author

Ashish Mondal
DevOps Engineer | Kubernetes | Cloud | Observability

---
