# Databricks–Jenkins Lakehouse Project
End-to-end AWS Lakehouse infrastructure with modular Terraform and a Jenkins-based CI/CD pipeline (Jenkins setup currently in progress).

## Overview
This project builds a complete AWS-based Lakehouse architecture using Terraform modules, including S3 (bronze/silver/gold), Glue Catalog, IAM roles, and a developing Jenkins pipeline for automated Terraform plan/apply.  
The Jenkins CI/CD component is **not yet finished**, but the infrastructure modules are fully functional and deployable.

## Architecture

AWS S3 (bronze/silver/gold)
↑
│ Data ingestion / Delta (optional future)
│
AWS Glue Catalog + Crawlers
↑
│ IAM roles for controlled access
│
Databricks Workspace (Community Edition)
↑
│ Workspace-level management only
│
Terraform (modules)
↑
│ CI/CD on Jenkins (setup in progress)
│
S3 backend + DynamoDB lock (bootstrap stack)

## Repository Structure

databricks-jenkins-lakehouse/
├── terraform-bootstrap/
│ ├── main.tf
│ ├── backend.tf
│ └── terraform.tfvars
├── terraform/
│ ├── main.tf
│ ├── variables.tf
│ ├── outputs.tf
│ └── modules/
│ ├── s3_data_lake/
│ ├── iam_glue/
│ ├── iam_databricks/
│ └── glue_catalog/
├── jenkins/
│ ├── Dockerfile ← Jenkins environment (NOT FULLY DONE)
│ └── docker-compose.yml ← Jenkins container (NOT FULLY DONE)
└── README.md

## Components

### **1. AWS S3 Data Lake**
- bronze / silver / gold buckets  
- default SSE encryption  
- explicit DENY rules removed (Databricks CE limitation)  
- lifecycle rules optional

### **2. AWS Glue Catalog**
- databases + crawlers for each layer  
- crawler IAM role: `lakehouse-dev-glue-crawler-role-access`  
- Terraform-managed, reproducible design

### **3. IAM Roles**
- Glue crawler role  
- Databricks data access role  
- raw JSON assume-role policies  
- least privilege enforced

### **4. Databricks Workspace**
- Community Edition  
- No Unity Catalog  
- No storage credentials  
- No external locations  
- Only workspace-level provisioning supported

### **5. Jenkins CI/CD (IN PROGRESS)**
Jenkins is **being built but not yet complete**.

Current status:
- Jenkins container builds successfully  
- Docker CLI added for future Terraform execution  
- Git checkout issues fixed (safe.directory, permissions)  
- Terraform will run **natively** inside Jenkins (not dockerized Terraform)

Pending tasks:
- Configure pipeline stages (Init/Plan/Validate/Manual Apply)  
- Add credential binding  
- Add GitHub SSH key / token  
- Finalize Jenkinsfile  
- Test pipeline end-to-end  

## Terraform State Management

### **1. Backend (terraform-bootstrap)**
- S3 bucket for remote state  
- DynamoDB table for locking  
- Fully isolated stack  
- Must be deployed before any other module  

### **2. Main Infrastructure**
- Uses the backend from bootstrap  
- No local state  
- Idempotent module execution  

## Security
- Least privilege IAM  
- S3 bucket encryption  
- No hardcoded credentials  
- Jenkins will use secure authentication (OIDC planned)  
- No Unity Catalog (unsupported in CE)

## Setup

### **1. Bootstrap (backend)**

cd terraform-bootstrap
terraform init
terraform apply

### **2. Main Infrastructure**

cd terraform
terraform init
terraform validate
terraform plan
terraform apply

### **3. Jenkins (in progress)**

## Limitations (Databricks CE)
- No Unity Catalog  
- No external locations  
- No storage credentials  
- No S3 write via IAM roles  
- Only workspace-level resources supported  
→ Terraform modules already updated accordingly.

## Roadmap
- Finish Jenkins pipeline configuration (**next priority**)  
- Add GitHub OIDC for Terraform Apply  
- Add EC2 Jenkins runner (production-ready)  
- Add Databricks Jobs (workspace-level)  
- Add Glue scheduled crawlers  
- Add Delta Live Tables (optional)

## Status Summary
- Terraform modules: **DONE**  
- Backend bootstrap: **DONE**  
- S3/Glue/IAM infra: **DONE**  
- Databricks CE adaptations: **DONE**  
- Jenkins container: **PARTIALLY DONE**  
- Jenkins pipeline: **NOT FULLY COMPLETE**  
- OIDC: **NOT STARTED**  