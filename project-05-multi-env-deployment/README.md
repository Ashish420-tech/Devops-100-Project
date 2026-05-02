# 🚀 Project 05: Multi-Environment CI/CD Pipeline

## 📌 Overview

This project demonstrates a **production-style CI/CD pipeline** using **GitHub Actions**, Docker, and multi-environment deployment workflows.

The pipeline automates:

* Building a Docker image
* Pushing it to DockerHub
* Deploying across environments (Dev → Staging → Production)
* Enforcing approval gates before production release

---

## 🧱 Architecture

```text
Developer → Git Push → GitHub Actions
        → Build Docker Image
        → Push to DockerHub
        → Deploy to DEV
        → Deploy to STAGING
        → Approval Required
        → Deploy to PRODUCTION
```

---

## 🛠️ Tech Stack

* **CI/CD**: GitHub Actions
* **Containerization**: Docker
* **Registry**: DockerHub
* **Backend App**: Node.js (Express)
* **Version Control**: Git + GitHub

---

## 📂 Project Structure

```bash
project-05-multi-env-deployment/
│
├── app/
│   ├── index.js
│   ├── package.json
│   ├── Dockerfile
│   └── .dockerignore
│
├── k8s/                 # (reserved for future use)
│
└── README.md
```

---

## ⚙️ CI/CD Workflow

The pipeline is defined in:

```bash
.github/workflows/deploy.yml
```

### 🔄 Workflow Stages

1. **Build Stage**

   * Checkout code
   * Build Docker image
   * Tag image using commit SHA

2. **Push Stage**

   * Authenticate with DockerHub
   * Push image to registry

3. **Deployment Stages**

   * **DEV** → automatic deployment
   * **STAGING** → sequential promotion
   * **PRODUCTION** → manual approval required

---

## 🔐 Secrets Configuration

Configured in GitHub:

```text
DOCKERHUB_USERNAME
DOCKERHUB_TOKEN
```

These are used for secure DockerHub authentication.

---

## 🧪 Application Details

A simple Node.js app is used to demonstrate environment-based deployment:

```javascript
const ENV = process.env.NODE_ENV || "dev";
```

This allows different behavior across environments.

---

## ▶️ How to Run Locally

```bash
cd app

# Install dependencies
npm install

# Run application
node index.js
```

Access:

```
http://localhost:4000
```

---

## 🐳 Docker Usage

```bash
# Build image
docker build -t multi-env-app .

# Run container
docker run -p 4000:4000 multi-env-app
```

---

## 🔄 Pipeline Trigger

The workflow is triggered on:

```yaml
on:
  push:
    branches:
      - main
```

---

## 🧠 Key Learnings

* Designing **multi-stage CI/CD pipelines**
* Managing **environment-based deployments**
* Using **Docker in CI workflows**
* Securing pipelines using **GitHub Secrets**
* Implementing **approval gates for production**
* Structuring repositories for scalable DevOps projects

---

## ⚠️ Notes

* Real server deployment via SSH is optional and handled in advanced projects
* Kubernetes deployment is covered in upcoming projects

---

## 📌 Status

```text
Project 05: Multi-Environment CI/CD Pipeline ✅ Completed
```

---

## 🔗 Future Improvements

* Integrate Kubernetes deployment
* Add Helm charts
* Implement rollback strategy
* Add automated testing stage
* Introduce security scanning (Trivy)

---

## 🙌 Author

**Ashish Mondal**
DevOps Enthusiast | Cloud & Kubernetes Learner

---

