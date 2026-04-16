# 🚀 Project 4: GitOps Deployment Pipeline with ArgoCD + Helm

## 📌 Overview

This project demonstrates a **complete GitOps workflow** using **ArgoCD, Kubernetes, Helm, and GitHub**.
The system ensures that the Kubernetes cluster state is always synchronized with the Git repository, making Git the **single source of truth**.

---

## 🧠 Architecture

GitHub (Helm Chart) → ArgoCD → Kubernetes Cluster

* GitHub stores Helm charts
* ArgoCD watches Git repo
* Automatically syncs changes
* Kubernetes runs the application

---

## 🛠️ Tech Stack

* Kubernetes (local cluster)
* ArgoCD
* Helm
* GitHub
* Nginx (demo application)

---

## 🚀 Features Implemented

* GitOps-based deployment
* Helm-based application packaging
* Auto Sync (Continuous Deployment)
* Self-healing & pruning
* ArgoCD Image Updater integration
* Real-time UI visualization of app state

---

## 📁 Project Structure

```
Devops-100-Project/
 └── project-4-gitops-demo/
      └── helm-chart/
          ├── Chart.yaml
          ├── values.yaml
          └── templates/
               ├── deployment.yaml
               ├── service.yaml
               └── serviceaccount.yaml
```

---

## ⚙️ Setup Steps

### 1️⃣ Install ArgoCD

```bash
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```

### 2️⃣ Access ArgoCD UI

```bash
kubectl port-forward svc/argocd-server -n argocd 8080:443
```

### 3️⃣ Get Admin Password

```bash
kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath='{.data.password}' | base64 -d
```

---

### 4️⃣ Create Helm Chart

```bash
helm create helm-chart
```

---

### 5️⃣ Create ArgoCD Application

`application.yaml`

```yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: project-4-app
  namespace: argocd
spec:
  project: default
  source:
    repoURL: https://github.com/Ashish420-tech/Devops-100-Project.git
    targetRevision: project-4-gitops-demo
    path: project-4-gitops-demo/helm-chart
  destination:
    server: https://kubernetes.default.svc
    namespace: default
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
```

---

## 🔥 Key Problems Faced & Solutions

---

### ❌ 1. ArgoCD Path Error

**Error:**

```
app path does not exist
```

**Cause:**
Incorrect path in `application.yaml`

**Fix:**

```yaml
path: project-4-gitops-demo/helm-chart
```

---

### ❌ 2. Helm Template Errors (nil pointer)

**Error:**

```
.Values.serviceAccount.create: nil pointer
```

**Cause:**
Missing values in `values.yaml`

**Fix:**
Added required fields:

```yaml
serviceAccount:
  create: true
```

---

### ❌ 3. Multiple Helm Errors (autoscaling, httpRoute, etc.)

**Cause:**
Default Helm chart contains unused templates

**Fix:**
Removed unnecessary files:

```bash
rm templates/httproute.yaml
rm templates/ingress.yaml
rm templates/hpa.yaml
rm templates/tests -rf
rm templates/NOTES.txt
```

---

### ❌ 4. Helm Render Failure

**Error during testing:**

```
helm template helm-chart
```

**Fix:**
Validated chart locally before pushing:

```bash
helm template helm-chart
```

---

### ❌ 5. Git Path Issue

**Error:**

```
pathspec did not match any files
```

**Cause:**
Wrong directory path

**Fix:**

```bash
git add project-4-gitops-demo/helm-chart
```

---

### ❌ 6. ArgoCD OutOfSync (even after sync)

**Cause:**
Kubernetes immutable field conflict

**Error:**

```
spec.selector field is immutable
```

**Fix:**

```bash
kubectl delete deployment nginx-demo
```

Then resync:

```bash
kubectl patch application project-4-app -n argocd -p '{"operation":{"sync":{}}}' --type=merge
```

---

### ❌ 7. Image Updater Installation Issue

**Error:**

```
404 Not Found (GitHub manifest)
```

**Fix:**
Installed via Helm:

```bash
helm install argocd-image-updater argo/argocd-image-updater -n argocd
```

---

## ✅ Final Outcome

* Application successfully deployed via Helm
* ArgoCD shows **Synced + Healthy**
* Fully automated GitOps pipeline working

---

## 🧪 Validation Test

Change replica count:

```yaml
replicaCount: 3
```

Push to Git → ArgoCD auto deploys → Pods scale automatically

---

## 🎯 Key Learnings

* Helm templates require correct values structure
* ArgoCD sync issues often relate to Git path or resource conflicts
* Kubernetes immutable fields require resource recreation
* Debugging is a core DevOps skill, not just setup

---

## 🏆 Resume Highlight

> Implemented a GitOps pipeline using ArgoCD and Helm with automated deployment, self-healing, and image update capabilities. Debugged real-world issues including Helm template failures and Kubernetes immutable field conflicts.

---

## 🚀 Future Improvements

* Multi-environment setup (dev/staging/prod)
* CI pipeline integration (GitHub Actions / Jenkins)
* Slack notifications from ArgoCD
* Custom Docker image auto deployment

=========================================================
📸 Screenshots
🔹 ArgoCD Dashboard (Synced & Healthy)

🔹 Application Resource Tree

🔹 Deployment View

🔹 Sync Status

🔹 Running Pods

🔹 Helm Template Output
---

## 👨‍💻 Author

Ashish Mondal
DevOps Learner → DevOps Engineer 🚀

---
