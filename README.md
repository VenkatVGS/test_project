# AWS DevOps Engineer Skill Test - Complete Implementation

## 🏆 Project Overview
This repository contains a complete AWS-native infrastructure implementation demonstrating enterprise DevOps practices across four phases:
- **Phase 1**: Infrastructure as Code with Terraform
- **Phase 2**: CI/CD Pipeline with GitHub Actions
- **Phase 3**: Monitoring, Logging & Alerting
- **Phase 4**: Security & Compliance

## 📋 Assessment Requirements Met

### ✅ Phase 1: Infrastructure as Code
**Design & Provision:**
- ✅ **Networking**: VPC with public/private subnets across 2 AZs, IGW, NAT Gateways, Route Tables
- ✅ **Compute**: EKS cluster with 2 node groups, Istio service mesh, Helm deployments
- ✅ **Data Storage**: RDS PostgreSQL (Multi-AZ), ElastiCache Redis, S3 buckets with encryption
- ✅ **Security**: IAM roles (least privilege), Security Groups, KMS encryption

**Deliverables:**
- ✅ Modular Terraform structure (`modules/` directory)
- ✅ Root configuration with variables and outputs
- ✅ Architecture diagram

### ✅ Phase 2: CI/CD Pipeline
**Build & Test:**
- ✅ Dockerized "hello-world" microservice (Python/Flask)
- ✅ Unit tests (pytest) and linting (flake8)
- ✅ SSM Parameter Store integration for configuration

**Pipeline Implementation:**
- ✅ GitHub Actions workflow on PR/push to master
- ✅ Steps: Security scan → Tests → Build → Deploy
- ✅ Zero-downtime rolling updates with Helm
- ✅ CloudWatch logging integration

**Deliverables:**
- ✅ `.github/workflows/ci-cd.yml`
- ✅ Demo script (`DEMO_SCRIPT.md`)
- ✅ Helm charts and Kubernetes manifests

### ✅ Phase 3: Monitoring & Alerting
**Metrics & Dashboards:**
- ✅ Custom CloudWatch metrics and dashboard
- ✅ Application latency and error rate monitoring

**Logging:**
- ✅ Centralized logs in CloudWatch with JSON formatting
- ✅ FluentBit DaemonSet for log collection
- ✅ PII filtering Lambda function

**Alerting:**
- ✅ CloudWatch Alarms:
  - CPU utilization > 80%
  - RDS replica lag > 100 ms
  - HTTP 5xx error rate > 5%
- ✅ SNS topic for notifications

### ✅ Phase 4: Security & Compliance
**Threat Detection & Policies:**
- ✅ GuardDuty enabled across account
- ✅ AWS Config rules:
  - S3 bucket encryption
  - RDS encryption
  - Restricted SSH access

**Secrets Management:**
- ✅ SSM Parameter Store with SecureString
- ✅ KMS encryption for secrets
- ✅ Runtime retrieval by application

**Google Gemini Integration:**
- ✅ CI workflow invokes Gemini for security scanning
- ✅ Automated security reports in PR comments
- ✅ Terraform code security analysis

## 🚀 Quick Start

### Prerequisites
- AWS Account with appropriate permissions
- Terraform 1.0+
- kubectl and helm
- GitHub repository with Actions enabled

### Deployment

1. **Clone and Initialize:**
   ```bash
   git clone https://github.com/VenkatVGS/test_project.git
   cd test_project/terraform
   terraform init

2. **Deploy the Infrastructure:**

terraform plan

terraform apply

3. **Trigger the CI/CD Pipeline:**

Follow the instructions in DEMO_SCRIPT.md, then push your changes to the main branch:

git add .
git commit -m "test: Trigger deployment"
git push origin master

4. **Verify Application Deployment:**

Check your pods and test the service:

kubectl get pods -l app=hello-world
kubectl run test-pod --image=curlimages/curl --rm -it --restart=Never -- curl http://hello-world:8080/

5. **Check Monitoring:**

View dashboards and alarms:

# View CloudWatch dashboard
aws cloudwatch get-dashboard --dashboard-name idurar-erp-dashboard

# Check alerts
aws cloudwatch describe-alarms

🏗️ Architecture

┌─────────────────┐    ┌──────────────────┐    ┌─────────────────┐
│   GitHub Actions│    │   AWS EKS        │    │   AWS RDS       │
│   CI/CD Pipeline│────│   Kubernetes     │────│   PostgreSQL    │
│   + Gemini Scan │    │   + Istio        │    │   Multi-AZ      │
└─────────────────┘    └──────────────────┘    └─────────────────┘
                              │
                              │
┌─────────────────┐    ┌──────────────────┐    ┌─────────────────┐
│   CloudWatch    │    │   ElastiCache    │    │   S3 Buckets    │
│   Monitoring    │    │   Redis Cluster  │    │   + Encryption  │
│   + Alerting    │    └──────────────────┘    └─────────────────┘
└─────────────────┘
                              │
┌─────────────────┐    ┌──────────────────┐
│   GuardDuty     │    │   AWS Config     │
│   + Config      │    │   Compliance     │
│   Security      │    └──────────────────┘
└─────────────────┘

📁 Repository Structure

project/
├── .github/workflows/
│   └── ci-cd.yml              # GitHub Actions workflow for build, test, scan & deploy
│
├── terraform/
│   ├── main.tf                # Root Terraform configuration
│   ├── variables.tf           # Input variables for modules
│   ├── outputs.tf             # Exported outputs
│   └── modules/               # Reusable Terraform modules
│       ├── vpc/               # Networking resources (VPC, subnets, IGW, NAT)
│       ├── eks/               # EKS cluster and node groups
│       ├── rds/               # PostgreSQL database (Multi-AZ)
│       ├── security/          # IAM, KMS, and security configurations
│       ├── monitoring/        # CloudWatch metrics, dashboards, alerts
│       └── istio/             # Istio service mesh setup
│
├── hello-world-service/       # Sample microservice
│   ├── app.py                 # Flask application source code
│   ├── test_app.py            # Unit tests using pytest
│   └── Dockerfile             # Docker image definition
│
├── helm-charts/               # Helm charts for Kubernetes deployment
│   └── hello-world/           # Helm chart for the Hello World service
│
├── DEMO_SCRIPT.md             # Step-by-step demo guide for CI/CD pipeline
└── README.md                  # Project documentation (this file)


🔧 Configuration:

Environment Variables:

AWS_REGION: ap-south-1

EKS_CLUSTER_NAME: idurar-erp-cluster

RDS_IDENTIFIER: idurar-erp-postgres

SSM Parameters:

/idurar-erp/dev/DB_PASSWORD - Database credentials

/idurar-erp/dev/APP_SECRET - Application secret

/hello-world/message - Hello world message

📊 Monitoring & Logging

Dashboard: CloudWatch dashboard idurar-erp-dashboard

Log Groups: /eks/idurar-erp-cluster/hello-world

Alarms: CPU, RDS lag, HTTP errors with SNS notifications

🔒 Security Features

Encryption: All data encrypted at rest (KMS)

Network Security: Private subnets, security groups

Access Control: IAM roles with least privilege

Compliance: AWS Config rules for best practices

Threat Detection: GuardDuty with active monitoring

Secrets Management: SSM Parameter Store with encryption

🛠️ Troubleshooting

Common Issues

Terraform State Locked:

terraform force-unlock [LOCK_ID]

EKS Authentication:

aws eks update-kubeconfig --region ap-south-1 --name idurar-erp-cluster

Pipeline Failures:

Check GitHub Actions logs

Verify AWS credentials in secrets

Confirm ECR repository exists
