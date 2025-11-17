# Databricks–Jenkins Lakehouse Project
AWS-based Lakehouse infrastructure using modular Terraform.  
Databricks part is COMPLETE; Jenkins CI/CD pipeline is IN PROGRESS.

## Overview
This project provides a modular Terraform setup to build an AWS Lakehouse architecture.  
It includes S3 bronze/silver/gold layers, Glue Catalog, IAM roles, and a Jenkins pipeline (in progress).

## Architecture
Terraform → S3 backend → DynamoDB lock  
↓  
AWS S3 (bronze / silver / gold)  
↓  
AWS Glue Databases + Crawlers  
↓  
IAM Roles (Glue, Databricks workspace)  
↓  
Databricks Workspace (Community Edition)  
↓  
Jenkins CI/CD Pipeline (IN PROGRESS)

## Repository Structure
databricks-jenkins-lakehouse/  
 ├── terraform-bootstrap/  
 │   ├── main.tf  
 │   ├── backend.tf  
 │   └── terraform.tfvars  
 ├── terraform/  
 │   ├── main.tf  
 │   ├── variables.tf  
 │   ├── outputs.tf  
 │   └── modules/  
 │       ├── s3_data_lake/  
 │       ├── iam_glue/  
 │       ├── iam_databricks/  
 │       └── glue_catalog/  
 ├── jenkins/  
 │   ├── Dockerfile  
 │   └── docker-compose.yml  
 └── README.md

## AWS Components

### S3 Data Lake
- Bronze / Silver / Gold buckets  
- Default SSE encryption   
- Fully Terraform-managed  

### Glue Catalog
- Separate database per layer  
- One crawler per layer  
- IAM Role: lakehouse-dev-glue-crawler-role-access  
- Fully automated creation  

### IAM Roles
- Glue crawler IAM role  
- Databricks workspace IAM role (CE-compatible, no UC)  
- Raw JSON assume-role  
- Least privilege permissions  

## Databricks (Community Edition)
- No Unity Catalog  
- No external locations  
- No storage credentials  
- Workspace-level only  
- Terraform adjusted to CE limitations  

## Jenkins CI/CD (IN PROGRESS)

### Completed
- Jenkins container builds and runs  
- Docker CLI installed  
- Git checkout issues fixed  
- Terraform will run natively  

### Missing
- Jenkinsfile finalization  
- Pipeline steps: init, validate, plan, manual apply  
- Credentials binding  
- OIDC integration  
- End-to-end testing  

### Jenkins Dockerfile
FROM jenkins/jenkins:lts-jdk17  
USER root  
RUN apt-get update && apt-get install -y docker-cli && rm -rf /var/lib/apt/lists/*  
USER jenkins

## Setup

### 1. Backend (bootstrap)
cd terraform-bootstrap  
terraform init  
terraform apply  

### 2. Main Infrastructure
cd terraform  
terraform init  
terraform validate  
terraform plan  
terraform apply  

### 3. Jenkins (in progress)
cd jenkins  
docker compose up -d  

## Roadmap
- Complete Jenkins pipeline  
- Add GitHub OIDC  
- Run Jenkins on EC2  
- Automate Databricks workspace jobs  
- Add Glue crawler schedules  
