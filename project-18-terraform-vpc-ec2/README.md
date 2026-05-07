# Project 18 — Terraform AWS VPC and EC2 Infrastructure on AWS

## 📌 Overview

This project demonstrates how to provision a complete AWS networking and compute infrastructure using Terraform.

The infrastructure includes:

* Custom VPC
* Public and Private Subnets
* Internet Gateway
* NAT Gateway
* Route Tables
* Security Groups
* EC2 Instance
* Apache Web Server
* Terraform Outputs
* Infrastructure as Code (IaC)

The objective of this project is to understand how real-world AWS infrastructure can be provisioned, version controlled, and automated using Terraform.

---

# 🏗️ Architecture

```text
                    Internet
                        │
                ┌───────▼────────┐
                │ Internet Gateway│
                └───────┬────────┘
                        │
                ┌───────▼────────┐
                │     Public RT   │
                └───────┬────────┘
                        │
         ┌──────────────┴──────────────┐
         │                             │
┌────────▼────────┐         ┌─────────▼────────┐
│ Public Subnet-1 │         │ Public Subnet-2  │
│   EC2 Instance  │         │   NAT Gateway    │
└────────┬────────┘         └─────────┬────────┘
         │                              │
         │                              │
         │                    ┌────────▼────────┐
         │                    │   Private RT     │
         │                    └────────┬────────┘
         │                              │
         │               ┌──────────────┴──────────────┐
         │               │                             │
┌────────▼────────┐   ┌──▼────────────────┐
│ Private Subnet1 │   │ Private Subnet-2  │
└─────────────────┘   └───────────────────┘
```

---

# 🧰 Tools & Technologies

| Tool             | Purpose                 |
| ---------------- | ----------------------- |
| Terraform        | Infrastructure as Code  |
| AWS VPC          | Networking              |
| EC2              | Compute                 |
| Security Groups  | Firewall Rules          |
| NAT Gateway      | Private Internet Access |
| Internet Gateway | Public Internet Access  |
| Route Tables     | Traffic Routing         |
| Amazon Linux 2   | Operating System        |
| Apache HTTPD     | Web Server              |

---

# 🎯 Project Objectives

* Learn Infrastructure as Code (IaC)
* Build reusable AWS infrastructure
* Understand AWS networking concepts
* Deploy EC2 automatically
* Configure public and private subnets
* Implement secure SSH access
* Bootstrap EC2 using user_data
* Understand Terraform state management

---

# 📂 Project Structure

```bash
project-18-terraform-vpc-ec2/
│
├── ec2.tf
├── networking.tf
├── outputs.tf
├── provider.tf
├── security.tf
├── terraform.tfvars
├── userdata.sh
├── variables.tf
├── versions.tf
└── .gitignore
```

---

# ⚙️ Prerequisites

Before starting, ensure the following are installed:

## 1. Terraform

Verify installation:

```bash
terraform -version
```

Install Terraform:

[https://developer.hashicorp.com/terraform/downloads](https://developer.hashicorp.com/terraform/downloads)

---

## 2. AWS CLI

Verify installation:

```bash
aws --version
```

Install AWS CLI:

[https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)

---

## 3. Configure AWS Credentials

```bash
aws configure
```

Provide:

```text
AWS Access Key ID
AWS Secret Access Key
Region: ap-south-1
Output Format: json
```

Verify credentials:

```bash
aws sts get-caller-identity
```

---

# 🔑 Create EC2 Key Pair

Check existing key pairs:

```bash
aws ec2 describe-key-pairs --query 'KeyPairs[*].KeyName'
```

Create new key pair if needed:

```bash
aws ec2 create-key-pair \
--key-name devops100 \
--query 'KeyMaterial' \
--output text > devops100.pem
```

Set correct permissions:

```bash
chmod 400 devops100.pem
```

---

# 🛠️ Terraform Configuration

---

## versions.tf

Defines Terraform and provider versions.

```hcl
terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
```

---

## provider.tf

Configures AWS provider.

```hcl
provider "aws" {
  region = var.region
}
```

---

## variables.tf

Stores reusable variables.

```hcl
variable "region" {
  default = "ap-south-1"
}

variable "vpc_cidr" {
  default = "10.10.0.0/16"
}
```

---

## networking.tf

Creates:

* VPC
* Public Subnets
* Private Subnets
* Internet Gateway
* NAT Gateway
* Route Tables

Key resources:

```hcl
resource "aws_vpc" "main"
resource "aws_subnet" "public"
resource "aws_subnet" "private"
resource "aws_nat_gateway" "nat"
resource "aws_route_table" "public"
resource "aws_route_table" "private"
```

---

## security.tf

Creates Security Group with:

* HTTP access
* HTTPS access
* Restricted SSH access

```hcl
resource "aws_security_group" "web_sg"
```

---

## ec2.tf

Creates:

* Amazon Linux 2 EC2 instance
* Uses latest AMI dynamically
* Bootstraps Apache using user_data

```hcl
resource "aws_instance" "web"
```

---

## userdata.sh

Bootstraps Apache Web Server automatically.

```bash
#!/bin/bash

yum update -y

yum install -y httpd

systemctl enable httpd
systemctl start httpd

echo "<h1>Project 18 Terraform EC2</h1>" > /var/www/html/index.html
```

---

## outputs.tf

Exports useful information:

```hcl
output "public_ip"
output "public_dns"
output "vpc_id"
```

---

# 🚀 Deployment Steps

## Step 1 — Initialize Terraform

```bash
terraform init
```

---

## Step 2 — Format Files

```bash
terraform fmt
```

---

## Step 3 — Validate Configuration

```bash
terraform validate
```

Expected:

```text
Success! The configuration is valid.
```

---

## Step 4 — Preview Infrastructure

```bash
terraform plan
```

Expected:

```text
Plan: 16 to add, 0 to change, 0 to destroy
```

---

## Step 5 — Deploy Infrastructure

```bash
terraform apply
```

Type:

```text
yes
```

Terraform provisions:

* VPC
* NAT Gateway
* Internet Gateway
* EC2 Instance
* Security Groups
* Route Tables
* Elastic IP

---

# ✅ Verification

## Terraform Outputs

```bash
terraform output
```

Example:

```text
public_ip = "13.206.xxx.xxx"
public_dns = "ec2-13-206-xxx-xxx.ap-south-1.compute.amazonaws.com"
vpc_id = "vpc-xxxxxxxx"
```

---

## Access Web Server

Open in browser:

```text
http://PUBLIC_IP
```

Expected output:

```text
Project 18 Terraform EC2
```

---

## Verify EC2 Instance

```bash
aws ec2 describe-instances \
--query 'Reservations[*].Instances[*].[InstanceId,State.Name,PublicIpAddress]' \
--output table
```

---

## Verify NAT Gateway

```bash
aws ec2 describe-nat-gateways \
--query 'NatGateways[*].[NatGatewayId,State]' \
--output table
```

---

## SSH Into EC2

```bash
ssh -i devops100.pem ec2-user@PUBLIC_IP
```

---

## Verify Apache Service

```bash
systemctl status httpd
```

Expected:

```text
active (running)
```

---

# 📸 Recommended Screenshots

Include these screenshots in your GitHub repository:

* Terraform init
* Terraform plan
* Terraform apply
* AWS VPC Dashboard
* Subnets
* Route Tables
* NAT Gateway
* EC2 Running State
* Apache Browser Output
* Security Group Rules

These improve recruiter visibility and project presentation.

---

# 🧠 Key Learning Outcomes

After completing this project, you will understand:

* Terraform workflow
* Infrastructure as Code
* AWS VPC networking
* Public vs Private subnets
* NAT Gateway architecture
* Route tables and routing
* Security Groups
* EC2 provisioning
* User Data automation
* Terraform dependency graph
* Terraform outputs

---

# 🎤 Interview Questions

## 1. What is Terraform?

Terraform is an Infrastructure as Code tool used to provision and manage infrastructure using declarative configuration files.

---

## 2. What is Infrastructure as Code?

Infrastructure as Code (IaC) is the process of managing infrastructure using code instead of manual configuration.

---

## 3. Difference Between Public and Private Subnet?

| Public Subnet            | Private Subnet                    |
| ------------------------ | --------------------------------- |
| Accessible from Internet | No direct Internet access         |
| Uses Internet Gateway    | Uses NAT Gateway                  |
| Hosts web servers        | Hosts internal services/databases |

---

## 4. Why Use NAT Gateway?

NAT Gateway allows private subnet resources to access the Internet securely without exposing them publicly.

---

## 5. What is Terraform State?

Terraform state stores infrastructure metadata and resource mappings.

---

## 6. What is User Data?

User Data is a bootstrap script executed automatically during EC2 instance launch.

---

## 7. What is a Security Group?

Security Group acts as a virtual firewall controlling inbound and outbound traffic.

---

# ⚠️ Common Errors

## Invalid CIDR

```text
invalid CIDR address
```

Fix:

Use valid CIDR block format.

---

## Invalid Key Pair

```text
InvalidKeyPair.NotFound
```

Fix:

Create or use existing EC2 key pair.

---

## NAT Gateway Creation Failure

Possible reasons:

* Missing Internet Gateway
* Missing Elastic IP
* Incorrect subnet association

---

# 💰 Cost Awareness

This project provisions billable AWS resources:

* NAT Gateway
* Elastic IP
* EC2 Instance

⚠️ NAT Gateway continues billing even when idle.

Destroy infrastructure after testing.

---

# 🧹 Cleanup

Destroy all infrastructure:

```bash
terraform destroy
```

Type:

```text
yes
```

---

# 🔒 .gitignore

```gitignore
.terraform/
*.tfstate
*.tfstate.backup
terraform.tfvars
```

---

# 📦 Git Commands

## Initialize Git

```bash
git init
```

---

## Commit Code

```bash
git add .
git commit -m "Project 18: Terraform AWS VPC and EC2 infrastructure deployment"
```

---

## Push to GitHub

```bash
git remote add origin <repo-url>
git branch -M main
git push -u origin main
```

---

# 🌟 Future Enhancements

You can improve this project further by implementing:

* Terraform Modules
* Application Load Balancer
* Auto Scaling Group
* Bastion Host
* Remote Backend (S3 + DynamoDB)
* Route53 Domain
* HTTPS with ACM
* Multi-environment deployment
* CI/CD Pipeline
* EKS with Terraform

---

# 🏁 Conclusion

This project demonstrates practical Infrastructure as Code implementation using Terraform and AWS.

It covers foundational cloud networking, EC2 provisioning, automation, and secure infrastructure design.

Completing this project provides strong hands-on understanding of:

* Terraform
* AWS Networking
* EC2 Automation
* Infrastructure Provisioning
* Cloud Security Basics
* DevOps Practices

This is an excellent beginner-to-intermediate DevOps portfolio project and a strong addition to GitHub and resume portfolios.
