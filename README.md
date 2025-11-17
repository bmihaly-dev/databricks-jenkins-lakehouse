<h1 align="center">🚀 Databricks–Jenkins Lakehouse Project</h1>
<p align="center">Modern AWS Lakehouse Infrastructure • Modular Terraform • Jenkins CI/CD Pipeline (WIP)</p>
<p align="center">Databricks: ✅ Complete • Jenkins: 🟡 In Progress</p>

---

## 🔧 Overview
This project implements a modern AWS-based Lakehouse architecture using modular Terraform.  
It includes S3 bronze/silver/gold layers, AWS Glue Catalog, IAM roles, and a Jenkins CI/CD pipeline (currently in progress).

---

## 🏗 Architecture
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

---

## 📁 Repository Structure
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

---

## ☁️ AWS Components

### 🪣 S3 Data Lake
- Bronze / Silver / Gold buckets  
- SSE encryption enabled  
- Fully Terraform-managed  

### 🧩 AWS Glue Catalog
- One database per layer  
- One crawler per layer  
- IAM Role: `lakehouse-dev-glue-crawler-role-access`  
- Automated via Terraform  

### 🔐 IAM Roles
- Glue crawler IAM role  
- Databricks workspace IAM role (no Unity Catalog)  
- Raw JSON assume-role  
- Least privilege  

---

## 🧠 Databricks (Community Edition)
- No Unity Catalog  
- No external locations  
- No storage credentials  
- Workspace-level only  
- Terraform modules adapted to CE limitations  

---

## 🛠 Jenkins CI/CD Pipeline (WIP)

### ✔ Completed
- Jenkins container builds and runs  
- Docker CLI installed  
- Git checkout issues fixed  
- Terraform will run natively  

### ❌ Still Missing
- Jenkinsfile finalization  
- Pipeline steps: init / validate / plan / manual apply  
- Credentials binding  
- GitHub OIDC  
- Full end-to-end automation  

---

## 🐳 Jenkins Dockerfile
FROM jenkins/jenkins:lts-jdk17  
USER root  
RUN apt-get update && apt-get install -y docker-cli && rm -rf /var/lib/apt/lists/*  
USER jenkins

---

## ▶️ Setup

### 1. Backend (bootstrap)
cd terraform-bootstrap  
terraform init  
terraform apply  

### 2. Main infrastructure
cd terraform  
terraform init  
terraform validate  
terraform plan  
terraform apply  

### 3. Jenkins (WIP)
cd jenkins  
docker compose up -d  

---

## 🗺 Roadmap
- Finish Jenkins pipeline  
- Add GitHub OIDC integration  
- Run Jenkins on EC2  
- Automate Databricks workspace jobs  
- Add Glue crawler schedules  
