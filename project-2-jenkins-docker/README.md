# 🚀 Project 2: Jenkins + Docker CI/CD Pipeline

## 📌 Overview

This project demonstrates a complete CI/CD pipeline using Jenkins and Docker on AWS EC2.

---

## ⚙️ Pipeline Flow

GitHub → Jenkins → Docker Build → DockerHub → Deployment

---

## 🛠️ Tools Used

* Jenkins (Docker)
* Docker
* AWS EC2
* GitHub
* Node.js

---

## 🚀 Stages

1. Checkout Code
2. Install & Test
3. Build Docker Image
4. Login to DockerHub
5. Push Image
6. Deploy Container

---

## 🐳 Docker Image

https://hub.docker.com/r/ashishmondal420/nodejs-app

---

## 🌐 Live App

http://65.0.95.15

---

## 📸 Screenshots

### Pipeline Success

![Pipeline](screenshots/pipeline.png)

### Console Output

![Console](screenshots/console.png)

### DockerHub Image

![DockerHub](screenshots/dockerhub.png)

### Running App

![App](screenshots/app.png)

---

## 🧠 Learnings

* Jenkins pipeline setup
* Docker integration
* CI/CD automation
* Debugging real-world issues

---

## ⚠️ Issues Faced

* Docker not accessible in Jenkins container
* Permission denied for docker.sock
* Missing credentials

---

## ✅ Final Outcome

Fully automated CI/CD pipeline with Docker deployment.
