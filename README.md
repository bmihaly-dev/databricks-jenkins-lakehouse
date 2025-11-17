# 🚀 Databricks–Jenkins Lakehouse Project
Modern AWS Lakehouse Infrastructure with Modular Terraform  
Databricks KÉSZ • Jenkins CI/CD folyamatban

## 🔧 Overview
Ez a projekt AWS-alapú Lakehouse architektúrát valósít meg moduláris Terraformmal.  
Tartalmaz S3 bronze/silver/gold rétegeket, Glue Catalogot, IAM szerepköröket és egy Jenkins CI/CD pipeline-t (folyamatban).

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

## ☁️ AWS Components

### 🪣 S3 Data Lake
- Bronze / Silver / Gold bucketek  
- SSE titkosítás   
- Terraform modulokkal kezelve  

### 🧩 Glue Catalog
- Külön adatbázis: bronze / silver / gold  
- Külön crawler minden réteghez  
- IAM role: lakehouse-dev-glue-crawler-role-access  
- Teljesen automatizált  

### 🔐 IAM Roles
- Glue crawler IAM role  
- Databricks workspace IAM role (Unity Catalog nélkül)  
- Raw JSON assume-role  
- Least privilege  

## 🧠 Databricks (Community Edition)
- Nincs Unity Catalog  
- Nincs external location  
- Nincs storage credential  
- Workspace-level működés  
- Terraform ehhez igazítva  

## 🛠 Jenkins CI/CD (IN PROGRESS)

### ✔ Kész:
- Jenkins container működik  
- Docker CLI telepítve  
- Git checkout hibák javítva  
- Terraform natívan fut majd Jenkinsben  

### ❌ Hiányzik:
- Jenkinsfile véglegesítése  
- Pipeline lépések: init / validate / plan / manual apply  
- Credential binding  
- OIDC integráció  
- Teljes pipeline teszt  

### Jenkins Dockerfile
FROM jenkins/jenkins:lts-jdk17  
USER root  
RUN apt-get update && apt-get install -y docker-cli && rm -rf /var/lib/apt/lists/*  
USER jenkins

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

### 3. Jenkins (in progress)
cd jenkins  
docker compose up -d  

## 🗺 Roadmap
- Jenkins pipeline befejezése  
- GitHub OIDC  
- EC2 Jenkins host  
- Databricks workspace automatizáció  
- Glue crawler schedule-ek  
