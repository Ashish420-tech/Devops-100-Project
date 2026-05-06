# Project 16 — Production-Style Rancher Multi-Cluster Kubernetes Platform on AWS

## Overview

This project demonstrates the implementation of a production-style Kubernetes management platform using Rancher and RKE2 on AWS. The goal was to centrally manage Kubernetes environments using Rancher while applying real-world DevOps and platform engineering practices.

The implementation included:

* AWS infrastructure provisioning
* Custom VPC networking
* EC2-based Kubernetes nodes
* RKE2 Kubernetes installation
* Helm package management
* cert-manager TLS automation
* Rancher deployment and configuration
* Infrastructure automation using Ansible
* Kubernetes troubleshooting and recovery
* Cloud infrastructure cleanup automation

This project was designed with a production mindset rather than a simple demo deployment.

---

# Architecture

## High-Level Architecture

```text
                    +-----------------------------+
                    |        Rancher UI           |
                    |  https://<public-ip>.sslip.io |
                    +-------------+---------------+
                                  |
                                  |
                     +------------v------------+
                     |     Rancher Server      |
                     |     RKE2 Cluster        |
                     +------------+------------+
                                  |
               -------------------------------------------
               |                                         |
    +----------v----------+                 +------------v-----------+
    |    Dev Cluster      |                 |      Prod Cluster      |
    |    (Future Import)  |                 |    (Future Import)     |
    +---------------------+                 +------------------------+
```

---

# Technologies Used

| Category                    | Tools / Services |
| --------------------------- | ---------------- |
| Cloud Provider              | AWS              |
| Kubernetes                  | RKE2             |
| Cluster Management          | Rancher          |
| Package Manager             | Helm             |
| TLS Automation              | cert-manager     |
| Automation                  | Ansible          |
| Infrastructure Provisioning | AWS CLI          |
| OS                          | Ubuntu 22.04     |
| Container Runtime           | containerd       |
| Networking                  | AWS VPC          |

---

# Objectives

The primary objectives of this project were:

* Build a centralized Kubernetes management platform
* Learn production-style Rancher deployment
* Practice Kubernetes operations
* Implement infrastructure automation
* Troubleshoot real cluster issues
* Manage cloud infrastructure lifecycle
* Simulate real-world platform engineering workflows

---

# Infrastructure Design

## AWS Resources Created

| Resource         | Purpose                              |
| ---------------- | ------------------------------------ |
| VPC              | Isolated network environment         |
| Public Subnet    | Internet-accessible Kubernetes nodes |
| Internet Gateway | External connectivity                |
| Route Table      | Routing configuration                |
| Security Group   | Controlled inbound access            |
| EC2 Instances    | Rancher and cluster nodes            |
| EBS Volumes      | Persistent node storage              |

---

# EC2 Topology

| Instance Name  | Purpose                             |
| -------------- | ----------------------------------- |
| rancher-server | Rancher + RKE2 control plane        |
| dev-cluster    | Future imported development cluster |
| prod-cluster   | Future imported production cluster  |

---

# Project Structure

```text
project-16-rancher-multicluster/
├── ansible/
├── backup/
├── docs/
├── fleet-gitops/
├── monitoring/
├── rancher-install/
├── screenshots/
├── README.md
└── .gitignore
```

## Directory Purpose

| Directory       | Purpose                               |
| --------------- | ------------------------------------- |
| ansible         | Infrastructure automation             |
| rancher-install | Rancher and RKE2 installation scripts |
| monitoring      | Prometheus and Grafana configuration  |
| backup          | Backup operator resources             |
| fleet-gitops    | GitOps deployment structure           |
| screenshots     | Project proof and visuals             |
| docs            | Supporting documentation              |

---

# Implementation Workflow

## 1. AWS Infrastructure Provisioning

Infrastructure was provisioned manually using AWS CLI commands to gain deeper understanding of:

* VPC networking
* Subnet routing
* Internet connectivity
* Security groups
* EC2 lifecycle management

### Components Configured

* Custom VPC
* Public subnet
* Internet Gateway
* Route table association
* SSH access
* Security group rules

---

## 2. Server Provisioning

Ubuntu-based EC2 instances were created for:

* Rancher server
* Development cluster
* Production cluster

The instances were configured with:

* Public IP addresses
* SSH key authentication
* Kubernetes prerequisites

---

## 3. Infrastructure Automation with Ansible

Ansible was used to automate:

* Server connectivity validation
* Package installation
* Kubernetes preparation
* System configuration

### Benefits

* Repeatable deployments
* Reduced manual work
* Infrastructure consistency
* Production-style automation workflow

---

# Kubernetes Setup

## RKE2 Installation

RKE2 was installed as the Kubernetes distribution.

### Why RKE2?

* Lightweight and secure
* Production-focused
* Rancher-native ecosystem
* Simplified Kubernetes operations
* Embedded containerd runtime

### Verification

Cluster health was validated using:

```bash
kubectl get nodes
```

Expected status:

```text
Ready
```

---

# Helm Installation

Helm was installed for Kubernetes package management.

Used for:

* cert-manager deployment
* Rancher deployment
* Future monitoring stack installation

---

# cert-manager Deployment

cert-manager was installed to automate TLS certificate management.

### Namespace

```text
cert-manager
```

### Purpose

* HTTPS support
* Ingress TLS
* Rancher certificate management

---

# Rancher Deployment

Rancher was deployed using Helm.

### Rancher Features

* Centralized cluster management
* Kubernetes visibility
* RBAC support
* Multi-cluster operations
* Application management
* Monitoring integration

### Rancher Access

```text
https://<public-ip>.sslip.io
```

---

# Production Troubleshooting Scenario

One of the most important learning outcomes of this project was handling a real infrastructure issue.

## Issue Encountered

Rancher pods failed with:

```text
no space left on device
```

and:

```text
DiskPressure
```

### Root Cause

The default EC2 root volume size was insufficient for:

* RKE2 components
* Rancher image extraction
* containerd storage requirements

---

# Troubleshooting Performed

## Diagnostic Steps

* Checked pod events
* Verified DiskPressure condition
* Inspected filesystem utilization
* Reviewed Kubernetes node conditions
* Investigated containerd storage paths

---

# Infrastructure Recovery

## Live EBS Volume Expansion

The EC2 root volume was expanded live from:

```text
8 GB → 30 GB
```

### Steps Performed

* Modified EBS volume
* Extended partition
* Resized filesystem
* Restarted RKE2
* Recovered Rancher deployment

### Production Skills Demonstrated

* Cloud storage operations
* Linux filesystem resizing
* Kubernetes node recovery
* Infrastructure troubleshooting

---

# Rancher Validation

Successful validation included:

* Rancher UI accessibility
* Healthy Kubernetes node
* Active local cluster
* Running Rancher workloads
* Functional ingress routing

---

# Security Considerations

The following security concepts were applied:

* SSH key-based access
* Security group restrictions
* TLS-enabled Rancher access
* Isolated VPC networking

---

# Cost Management

Infrastructure cleanup automation was implemented to avoid unnecessary AWS charges.

## Cleanup Included

* EC2 termination
* VPC deletion
* Security group cleanup
* Internet gateway removal
* Route table cleanup
* EBS verification
* AWS account auditing

---

# AWS Audit Automation

A custom audit script was created to inspect:

* EC2 instances
* EBS volumes
* Elastic IPs
* NAT Gateways
* Load Balancers
* RDS instances
* EKS clusters
* S3 buckets

This simulated real-world cloud governance practices.

---

# Key Learning Outcomes

## Kubernetes

* RKE2 operations
* Node troubleshooting
* Pod lifecycle debugging
* Kubernetes networking
* Storage troubleshooting

## AWS

* VPC networking
* EC2 provisioning
* EBS operations
* Cloud infrastructure lifecycle
* Cost optimization

## DevOps & Platform Engineering

* Infrastructure automation
* Configuration management
* Production troubleshooting
* Cluster operations
* Platform lifecycle management

---

# Challenges Faced

| Challenge                       | Resolution                             |
| ------------------------------- | -------------------------------------- |
| SSH connectivity issues         | Route table and internet gateway fixes |
| kubeconfig permission errors    | Updated kubeconfig permissions         |
| Rancher image pull failures     | Increased EBS volume size              |
| DiskPressure on Kubernetes node | Live storage expansion                 |
| Kubernetes pod failures         | RKE2 restart and recovery              |

---

# Future Improvements

Potential future enhancements:

* Import dev and prod clusters into Rancher
* Configure Fleet GitOps
* Deploy Prometheus and Grafana
* Add Alertmanager notifications
* Configure Rancher Backup Operator
* Integrate external DNS
* Add CI/CD pipelines
* Enable centralized logging

---

# Skills Demonstrated

This project demonstrates practical experience with:

* Kubernetes Administration
* Rancher Platform Management
* AWS Infrastructure
* Linux Administration
* Infrastructure Automation
* Helm Deployments
* Cloud Networking
* Production Troubleshooting
* Storage Management
* Platform Engineering

---

# Resume Summary

Built a production-style multi-cluster Kubernetes management platform on AWS using Rancher and RKE2 with automated infrastructure provisioning via AWS CLI, server configuration using Ansible, Helm-based application deployment, TLS automation using cert-manager, and real-world Kubernetes troubleshooting including DiskPressure recovery and live EBS filesystem expansion.

---

# Conclusion

This project successfully implemented a production-style Rancher management platform on AWS while demonstrating real-world DevOps and platform engineering practices.

Beyond Kubernetes deployment, the project focused heavily on:

* operational reliability
* infrastructure troubleshooting
* automation
* cloud lifecycle management
* production recovery workflows

The implementation provided hands-on experience with the full lifecycle of cloud-native infrastructure:

```text
Provision → Configure → Deploy → Troubleshoot → Operate → Destroy → Audit
```

This project significantly strengthened practical understanding of Kubernetes operations and cloud platform engineering.
