# Project 17 — Amazon EKS Cluster Provisioning with Terraform

## Overview

This project demonstrates how to provision a production-style Amazon EKS (Elastic Kubernetes Service) cluster using Terraform.

The infrastructure includes:

* Custom VPC
* Public and Private Subnets
* Internet Gateway
* NAT Gateway
* Route Tables
* EKS Control Plane
* Managed Node Group
* IAM Roles and Policies
* Kubernetes connectivity using kubectl

This project is designed to simulate a real-world DevOps infrastructure deployment workflow.

---

# Architecture

```text
                        Internet
                            │
                    Internet Gateway
                            │
                   ┌─────────────────┐
                   │      VPC        │
                   │   10.0.0.0/16  │
                   └─────────────────┘
                     │             │
         ┌───────────┘             └───────────┐
         │                                     │
 ┌────────────────┐                 ┌────────────────┐
 │ Public Subnets │                 │ Private Subnets│
 │                │                 │                │
 │ NAT Gateway    │                 │ EKS Nodes      │
 │ Load Balancer  │                 │ Kubernetes Pods│
 └────────────────┘                 └────────────────┘
                                                 │
                                         Amazon EKS Cluster
```

---

# Tools & Technologies

| Tool      | Purpose                         |
| --------- | ------------------------------- |
| Terraform | Infrastructure as Code          |
| AWS EKS   | Managed Kubernetes              |
| AWS VPC   | Networking                      |
| IAM       | Access Management               |
| kubectl   | Kubernetes CLI                  |
| AWS CLI   | AWS Authentication & Management |

---

# Project Structure

```text
project-17-eks-terraform/
├── README.md
├── provider.tf
├── versions.tf
├── variables.tf
├── terraform.tfvars
├── outputs.tf
├── main.tf
│
├── modules/
│   ├── vpc/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   │
│   └── eks/
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
│
├── environments/
│   └── dev/
│
└── scripts/
    └── init.sh
```

---

# Prerequisites

Before starting, ensure the following tools are installed.

## Verify Terraform

```bash
terraform version
```

## Verify AWS CLI

```bash
aws --version
```

## Verify kubectl

```bash
kubectl version --client
```

---

# AWS Authentication

Configure AWS CLI:

```bash
aws configure
```

Provide:

* AWS Access Key
* AWS Secret Key
* Region
* Output format

Verify authentication:

```bash
aws sts get-caller-identity
```

---

# Terraform Initialization

Initialize Terraform:

```bash
terraform init
```

Validate configuration:

```bash
terraform validate
```

Generate execution plan:

```bash
terraform plan
```

---

# VPC Module

The VPC module provisions:

* VPC
* Public Subnets
* Private Subnets
* Internet Gateway
* NAT Gateway
* Route Tables
* Route Table Associations

## Public Subnets

Used for:

* NAT Gateway
* Load Balancers

## Private Subnets

Used for:

* EKS Worker Nodes
* Kubernetes Workloads

---

# Important Subnet Tags

Public subnet tags:

```hcl
"kubernetes.io/role/elb" = "1"
"kubernetes.io/cluster/devops-eks-cluster" = "shared"
```

Private subnet tags:

```hcl
"kubernetes.io/role/internal-elb" = "1"
"kubernetes.io/cluster/devops-eks-cluster" = "shared"
```

These tags are required for:

* EKS networking
* LoadBalancer services
* Node group integration

---

# EKS Module

The EKS module provisions:

* EKS Cluster
* Cluster IAM Role
* Worker Node IAM Role
* Managed Node Group

---

# IAM Roles Used

## Cluster Role

Attached Policy:

```text
AmazonEKSClusterPolicy
```

Purpose:

* Allows EKS control plane to manage AWS resources.

---

## Node Role

Attached Policies:

```text
AmazonEKSWorkerNodePolicy
AmazonEC2ContainerRegistryReadOnly
AmazonEKS_CNI_Policy
```

Purpose:

* Join nodes to cluster
* Pull container images
* Enable Kubernetes networking

---

# Managed Node Group

The worker nodes are deployed using:

```text
aws_eks_node_group
```

Configuration:

| Parameter     | Value                  |
| ------------- | ---------------------- |
| Instance Type | t3.medium              |
| Desired Nodes | 2                      |
| Min Nodes     | 1                      |
| Max Nodes     | 3                      |
| Capacity Type | ON_DEMAND              |
| AMI Type      | AL2023_x86_64_STANDARD |

---

# Kubernetes Version Compatibility

This project uses:

```text
EKS Version: 1.29
```

Important:

For Kubernetes 1.29, the following AMI type was required:

```hcl
ami_type = "AL2023_x86_64_STANDARD"
```

Using older Amazon Linux 2 AMIs caused node group provisioning failures.

---

# Deploy Infrastructure

## Create Plan File

```bash
terraform plan -out=eks.tfplan
```

## Apply Infrastructure

```bash
terraform apply eks.tfplan
```

---

# Configure kubectl

Connect kubectl to EKS cluster:

```bash
aws eks update-kubeconfig \
--region ap-south-1 \
--name devops-eks-cluster
```

---

# Verify Cluster

## Check Nodes

```bash
kubectl get nodes
```

Expected:

```text
NAME                                  STATUS   ROLES    AGE   VERSION
ip-10-0-x-x.ap-south-1.compute.internal   Ready    <none>   2m    v1.29
```

---

# Verify Kubernetes System Pods

```bash
kubectl get pods -A
```

Expected system components:

* CoreDNS
* kube-proxy
* aws-node

---

# Troubleshooting

## Issue: Requested AMI for this version 1.29 is not supported

### Cause

Amazon Linux 2 AMI incompatibility with EKS 1.29.

### Fix

Use:

```hcl
ami_type = "AL2023_x86_64_STANDARD"
```

---

## Issue: NodeGroup already exists

### Cause

Terraform state drift after failed creation.

### Fix

Delete node group manually:

```bash
aws eks delete-nodegroup \
--cluster-name devops-eks-cluster \
--nodegroup-name dev-node-group
```

Then rerun:

```bash
terraform apply
```

---

## Issue: Terraform state lock

### Cause

Previous Terraform process still running.

### Fix

Check running processes:

```bash
ps -ef | grep terraform
```

Kill stuck process:

```bash
kill -9 <PID>
```

Unlock Terraform state:

```bash
terraform force-unlock <LOCK_ID>
```

---

# Terraform Commands Used

## Initialize

```bash
terraform init
```

## Validate

```bash
terraform validate
```

## Format

```bash
terraform fmt -recursive
```

## Plan

```bash
terraform plan
```

## Apply

```bash
terraform apply
```

## Destroy

```bash
terraform destroy
```

---

# Cost Considerations

Resources that incur charges:

| Resource    | Notes             |
| ----------- | ----------------- |
| NAT Gateway | High hourly cost  |
| EKS Cluster | Charged hourly    |
| EC2 Nodes   | Worker node cost  |
| Elastic IP  | Charged if unused |

Always destroy infrastructure after practice:

```bash
terraform destroy
```

---

# Key Learning Outcomes

This project demonstrates:

* Infrastructure as Code
* AWS Networking
* Kubernetes Architecture
* Terraform Modules
* IAM Roles & Policies
* Managed Kubernetes
* Production VPC Design
* Kubernetes Worker Nodes
* Troubleshooting EKS Provisioning

---

# Interview Questions

## Why are worker nodes placed in private subnets?

For improved security. Worker nodes are not directly exposed to the internet.

---

## What is the purpose of a NAT Gateway?

Allows private subnet resources to access the internet without exposing them publicly.

---

## Why use managed node groups?

AWS automatically handles:

* Scaling
* Updates
* Auto healing
* Lifecycle management

---

## Why use Terraform for EKS?

Benefits:

* Reproducibility
* Version control
* Automation
* Consistency
* Collaboration

---

# Resume Description

Provisioned a production-style Amazon EKS cluster using Terraform with modular VPC architecture, private worker nodes, managed node groups, IAM-based access control, Kubernetes networking, and Infrastructure as Code best practices.

---

# Conclusion

This project provides hands-on experience with:

* Kubernetes on AWS
* Terraform automation
* Cloud networking
* IAM security
* EKS troubleshooting
* Production-grade infrastructure design

It is an excellent intermediate-to-advanced DevOps portfolio project demonstrating real-world cloud engineering workflows.
