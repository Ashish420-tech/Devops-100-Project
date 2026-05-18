# Project 01 — End-to-End DevSecOps CI/CD Pipeline for Flask Application

## Overview

This project demonstrates a complete end-to-end DevSecOps CI/CD pipeline for deploying a Dockerized Flask application on AWS using Infrastructure as Code, Configuration Management, CI/CD automation, and security scanning.

The project starts from source code in GitHub, performs automated security validation, provisions infrastructure using Terraform, configures the EC2 server using Ansible, builds and tests the application with Jenkins, pushes Docker images to Docker Hub, and deploys the application automatically.

This project simulates a real-world DevOps delivery pipeline.

---

# Architecture

```text
Developer Push
      |
      v
GitHub Repository
      |
      v
GitHub Actions (DevSecOps CI)
   - Gitleaks Secret Scan
   - Security Validation
      |
      v
Terraform
   - AWS EC2 Provisioning
   - VPC / Subnet / Security Group
      |
      v
Ansible
   - Jenkins Installation
   - Docker Installation
   - Git Installation
   - Python Runtime Setup
      |
      v
Jenkins CI/CD Pipeline
   - Source Checkout
   - Python Unit Testing
   - Docker Build
   - Docker Push
   - Deployment
      |
      v
Docker Hub Registry
      |
      v
AWS EC2 Deployment
      |
      v
Live Flask Application
```

---

# Tech Stack

## Cloud
- AWS EC2
- AWS VPC
- AWS Security Groups

## Infrastructure as Code
- Terraform

## Configuration Management
- Ansible

## CI/CD
- Jenkins
- GitHub Actions

## Security
- Gitleaks
- Secret scanning

## Containerization
- Docker
- Docker Hub

## Application Stack
- Python
- Flask
- Pytest

## Version Control
- Git
- GitHub

---

# Project Structure

```bash
assignment-01-docker-flask-app/
│
├── app/
│   ├── app.py
│   └── requirements.txt
│
├── tests/
│   └── test_app.py
│
├── terraform/
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   └── terraform.tfvars
│
├── ansible/
│   ├── inventory
│   └── jenkins-setup.yml
│
├── .github/
│   └── workflows/
│       ├── ci.yml
│       └── gitleaks.yml
│
├── Dockerfile
├── Jenkinsfile
└── README.md
```

---

# Features Implemented

## Application
✔ Dockerized Flask application

## Infrastructure
✔ AWS EC2 provisioning with Terraform  
✔ Custom VPC setup  
✔ Public subnet configuration  
✔ Internet gateway setup  
✔ Security group configuration  

## Configuration Management
✔ Automated Jenkins installation using Ansible  
✔ Automated Docker installation  
✔ Automated Git installation  
✔ Automated Python runtime setup  

## DevSecOps
✔ GitHub secret scanning with Gitleaks  
✔ Hardcoded secret detection prevention  

## CI/CD
✔ Automated Jenkins pipeline  
✔ GitHub repository integration  
✔ Automated unit testing  
✔ Automated Docker image build  
✔ Automated Docker image push  
✔ Automated application deployment  

---

# Deployment Screenshots

## Application Running

Application URL:

```text
http://35.154.89.141:5000
```

Flask application successfully deployed on AWS EC2.

---

## Running Container

```bash
docker ps
```

Output:

```bash
CONTAINER ID   IMAGE                           STATUS
729fa4068f1c   ashishmondal420/multi-env-app  Up
```

---

# Prerequisites

Install the following:

- AWS CLI
- Terraform
- Ansible
- Docker
- Git
- Python 3
- Jenkins
- Docker Hub account

---

# Setup Instructions

# 1 Clone Repository

```bash
git clone https://github.com/Ashish420-tech/Devops-100-Project.git
cd Devops-100-Project/assignment-01-docker-flask-app
```

---

# 2 Configure AWS CLI

```bash
aws configure
```

Provide:

```text
AWS Access Key
AWS Secret Key
Region: ap-south-1
```

---

# 3 Terraform Infrastructure Provisioning

Navigate:

```bash
cd terraform
```

Initialize:

```bash
terraform init
```

Validate:

```bash
terraform validate
```

Plan:

```bash
terraform plan
```

Deploy:

```bash
terraform apply -auto-approve
```

Get EC2 IP:

```bash
terraform output public_ip
```

---

# 4 Configure Server Using Ansible

Navigate:

```bash
cd ../ansible
```

Update inventory:

```ini
[jenkins]
35.154.89.141 ansible_user=ubuntu ansible_ssh_private_key_file=/home/ashish/devops100.pem
```

Connectivity test:

```bash
ansible -i inventory jenkins -m ping
```

Run configuration:

```bash
ansible-playbook -i inventory jenkins-setup.yml
```

---

# 5 Jenkins Setup

Access Jenkins:

```text
http://35.154.89.141:8080
```

Retrieve password:

```bash
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
```

Install plugins:

- Pipeline
- Git
- Docker Pipeline
- Credentials Binding
- GitHub Integration

---

# 6 Docker Hub Credentials

Jenkins → Manage Credentials

Add:

```text
ID: dockerhub-creds
Username: Docker Hub username
Password: Docker Hub token
```

---

# 7 Jenkins Pipeline

Pipeline stages:

## Test

```bash
pytest
```

## Docker Build

```bash
docker build
```

## Docker Push

```bash
docker push
```

## Deployment

```bash
docker run
```

---

# Security Controls

Implemented controls:

- Git secret scanning
- Gitleaks validation
- Hardcoded credential detection
- Docker image control
- Credential injection through Jenkins secrets

---

# Troubleshooting

## Jenkins Not Accessible

Check:

```bash
sudo systemctl status jenkins
```

---

## Docker Permission Issue

Fix:

```bash
sudo usermod -aG docker jenkins
sudo systemctl restart jenkins
```

---

## Python venv Issue

Install:

```bash
sudo apt install python3-venv python3-pip
```

---

## Container Not Running

Check:

```bash
docker ps -a
```

Logs:

```bash
docker logs flask-app
```

---

## Terraform Region Issue

Ensure:

```hcl
ap-south-1
```

is correctly configured.

---

# Cleanup

Destroy infrastructure:

```bash
cd terraform
terraform destroy -auto-approve
```

Remove local Docker image:

```bash
docker rmi ashishmondal420/multi-env-app
```

---

# Interview Explanation

This project demonstrates practical implementation of:

- Infrastructure provisioning using Terraform
- Configuration management using Ansible
- Jenkins pipeline automation
- GitHub DevSecOps validation
- Docker image lifecycle management
- AWS application deployment
- Secure CI/CD workflows

Interview summary:

> "I built an end-to-end DevSecOps CI/CD pipeline where GitHub triggers security validation, Terraform provisions AWS infrastructure, Ansible configures Jenkins and Docker, Jenkins executes automated testing and Docker image delivery, and the application is deployed automatically to AWS EC2."

---

# Future Enhancements

- HTTPS with Nginx reverse proxy
- Kubernetes deployment
- Helm charts
- Prometheus monitoring
- Grafana dashboards
- Trivy container image scanning
- ArgoCD GitOps deployment
- EKS migration

---

# Author

Ashish Mondal

GitHub:
https://github.com/Ashish420-tech

Docker Hub:
https://hub.docker.com/u/ashishmondal420
