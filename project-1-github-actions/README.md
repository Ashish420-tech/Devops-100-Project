# 🚀 DevOps Project 1: End-to-End CI/CD Pipeline with GitHub Actions, Docker & AWS EC2

## 📌 Overview

This project demonstrates a complete **CI/CD pipeline** that automates the process of building, testing, containerizing, and deploying a Node.js application to AWS EC2.

It reflects a real-world DevOps workflow used in production environments.

---

## 🧰 Tech Stack

* **Version Control**: Git, GitHub
* **CI/CD**: GitHub Actions
* **Containerization**: Docker
* **Cloud**: AWS EC2 (Amazon Linux 2023)
* **Runtime**: Node.js

---

## ⚙️ Architecture

```text
Developer → GitHub → GitHub Actions (CI/CD)
                ↓
         Build & Test (Node.js)
                ↓
         Docker Image Build
                ↓
         Push to Docker Hub
                ↓
        Deploy to AWS EC2 (SSH)
                ↓
         Run Container (Port 80)
```

---

## 🚀 Pipeline Workflow

### 1. Code Push

* Developer pushes code to GitHub branch
* Triggers GitHub Actions workflow

### 2. Continuous Integration (CI)

* Install dependencies (`npm ci`)
* Run tests (`npm test`)
* Build application (`npm run build`)

### 3. Docker Build & Push

* Build Docker image
* Push image to Docker Hub

### 4. Continuous Deployment (CD)

* SSH into EC2 instance
* Pull latest Docker image
* Stop & remove old container
* Run new container

---

## 📂 Project Structure

```text
Devops-100-Project/
│
├── nodejs-app/
│   ├── index.js
│   ├── package.json
│   ├── package-lock.json
│   └── Dockerfile
│
└── .github/
    └── workflows/
        └── ci.yml
```

---

## 🔐 GitHub Secrets

The following secrets are configured for secure CI/CD:

* `DOCKERHUB_USERNAME`
* `DOCKERHUB_TOKEN`
* `SERVER_HOST`
* `SERVER_USER`
* `SERVER_SSH_KEY`

---

## 🌐 Deployment

* Application deployed on AWS EC2
* Accessible via Public IP:

```
http://<EC2-PUBLIC-IP>
```

---

## 🧪 Troubleshooting Scenarios Practiced

This project includes intentional failure testing:

* ❌ Missing `index.js` → Container crash
* ❌ Invalid Docker base image → Build failure
* ❌ Wrong Docker credentials → Push failure
* ❌ Wrong workflow trigger → Pipeline not running

---

## 🎯 Key Learnings

* End-to-end CI/CD pipeline design
* GitHub Actions workflow creation
* Docker image lifecycle
* Secure credential management (GitHub Secrets)
* AWS EC2 deployment automation
* Real-world debugging and failure handling

---

## 📈 Outcome

Successfully built and deployed a production-style CI/CD pipeline that:

* Automates build, test, and deployment
* Uses containerization for consistency
* Implements secure authentication mechanisms
* Demonstrates real DevOps practices

---

## 👨‍💻 Author

**Ashish Mondal**
DevOps Enthusiast | Cloud & Automation Learner

---

## ⭐ Next Steps

* Jenkins Pipeline (Project 2)
* Kubernetes Deployment
* Infrastructure as Code (Terraform)
* Monitoring & Logging

---
