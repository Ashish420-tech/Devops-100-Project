# 🚀 Project 9: Helm Chart Development & Deployment (Production-Ready)

## 📌 Overview

This project demonstrates how to build a **production-quality Helm chart** for deploying an application on Kubernetes with **multi-environment support (dev, staging, prod)**.

It includes:

* Parameterized deployments using `values.yaml`
* Environment-specific configurations
* ConfigMap integration
* Helm lifecycle management (install, upgrade, uninstall)
* Real-world debugging scenarios

---

## 🧰 Tech Stack

* Kubernetes
* Helm 3
* Docker Hub (nginx image)
* YAML templating

---

## 📁 Project Structure

```
myapp/
├── Chart.yaml
├── values.yaml
├── values-dev.yaml
├── values-staging.yaml
├── values-prod.yaml
├── templates/
│   ├── deployment.yaml
│   ├── service.yaml
│   ├── configmap.yaml
│   ├── _helpers.tpl
│   └── NOTES.txt
```

---

# 🧭 PLAYBOOK (STEP-BY-STEP EXECUTION)

---

## 🔹 Step 1: Create Helm Chart

```
helm create myapp
cd myapp
```

Clean unnecessary files:

```
rm -rf templates/tests
```

---

## 🔹 Step 2: Configure Chart Metadata

Edit `Chart.yaml`:

```
apiVersion: v2
name: myapp
description: Production Helm chart
version: 1.0.0
appVersion: "1.0"
```

---

## 🔹 Step 3: Configure values.yaml

```
replicaCount: 1

image:
  repository: nginx
  tag: latest

service:
  type: ClusterIP
  port: 80

env: dev

ingress:
  enabled: false

autoscaling:
  enabled: false
```

---

## 🔹 Step 4: Multi-Environment Configurations

### values-dev.yaml

```
replicaCount: 1
env: dev
```

### values-staging.yaml

```
replicaCount: 2
env: staging
```

### values-prod.yaml

```
replicaCount: 3
env: production
```

---

## 🔹 Step 5: ConfigMap Integration

Create `templates/configmap.yaml`:

```
apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ .Release.Name }}
data:
  APP_ENV: {{ .Values.env | quote }}
```

---

## 🔹 Step 6: Deployment Template

Update `templates/deployment.yaml`:

```
replicas: {{ .Values.replicaCount }}

containers:
- name: nginx
  image: "{{ .Values.image.repository }}:{{ .Values.image.tag }}"
  envFrom:
    - configMapRef:
        name: {{ .Release.Name }}
```

---

## 🔹 Step 7: Service Template

```
apiVersion: v1
kind: Service
metadata:
  name: {{ .Release.Name }}
spec:
  type: {{ .Values.service.type }}
  ports:
    - port: {{ .Values.service.port }}
```

---

## 🔹 Step 8: Helper Templates

```
{{- define "myapp.fullname" -}}
{{ .Release.Name }}
{{- end }}
```

---

## 🔹 Step 9: Add NOTES.txt

```
Application deployed successfully!

kubectl get pods
kubectl get svc
```

---

## 🔹 Step 10: Lint Chart

```
helm lint .
```

---

## 🔹 Step 11: Package Chart

```
helm package .
```

---

## 🔹 Step 12: Deploy (Production)

```
helm install myapp-prod . -f values-prod.yaml
```

---

## 🔹 Step 13: Verify Deployment

```
kubectl get pods
kubectl get svc
kubectl describe configmap myapp-prod
```

Expected:

* 3 pods running
* APP_ENV=production

---

## 🔹 Step 14: Upgrade Deployment

```
helm upgrade myapp-prod . --set replicaCount=2
```

---

## 🔹 Step 15: Uninstall

```
helm uninstall myapp-prod
```

---

# 🐞 Troubleshooting Playbook

### ❌ Error: nil pointer

✔ Fix: Add missing keys in values.yaml

---

### ❌ Error: cluster unreachable

✔ Fix: Start Kubernetes cluster (minikube start)

---

### ❌ Error: immutable field

✔ Fix: uninstall and reinstall Helm release

---

### ❌ Pods not creating

✔ Fix: check ServiceAccount / labels mismatch

---

# 🎯 Key Learnings

* Helm templating with values.yaml
* Environment-based deployments
* Debugging Helm + Kubernetes issues
* Managing Helm release lifecycle
* Writing reusable infrastructure code

---

# 🚀 Outcome

✔ Reusable Helm chart
✔ Multi-environment deployment
✔ Production-ready configuration
✔ Real DevOps debugging experience

---

# 📌 Author

Ashish Mondal

---
