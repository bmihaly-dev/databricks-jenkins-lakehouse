# Databricks–Jenkins Lakehouse Project
AWS-alapú Lakehouse infrastruktúra modulos Terraformmal.  
A Databricks rész teljesen kész; a Jenkins CI/CD pipeline jelenleg fejlesztés alatt áll.

## Overview
Ez a projekt egy AWS-re épülő Lakehouse architektúrát valósít meg Terraformmal.  
Az infrastruktúra tartalmaz S3 (bronze/silver/gold) rétegeket, AWS Glue Catalogot, IAM szerepköröket és egy épülő Jenkins pipeline-t Terraform automatizáláshoz.

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
- bronze / silver / gold bucketek  
- alapértelmezett SSE titkosítás  
- explicit DENY szabályok eltávolítva (Databricks CE limitációk miatt)

### Glue Catalog
- külön adatbázis mindhárom réteghez  
- crawler minden buckethez  
- IAM szerepkör: lakehouse-dev-glue-crawler-role-access

### IAM Roles
- Glue crawler role  
- Databricks workspace role (CE-kompatibilis)  
- raw JSON assume-role policy  
- least privilege jogosultságok

## Databricks (Community Edition)
- nincs Unity Catalog  
- nincs external location  
- nincs storage credential  
- csak workspace-szintű erőforrások támogatottak  
- Terraform modulok mindezt figyelembe veszik

## Jenkins CI/CD (IN PROGRESS)

### Már kész:
- Jenkins konténer indul  
- Dockerfile Terraform-képes környezettel  
- Docker CLI telepítve  
- Git checkout hibák javítva  
- Terraform NEM dockerizált, hanem natívan fog futni

### Még hiányzik:
- Jenkinsfile véglegesítése  
- pipeline lépések: init, validate, plan, manual apply  
- credentials binding  
- pipeline tesztelése  
- OIDC integráció (később)

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

### 3. Jenkins (IN PROGRESS)
cd jenkins
docker compose up -d

## Roadmap
- Jenkins pipeline befejezése  
- GitHub OIDC integráció  
- EC2-alapú Jenkins futtatás  
- Databricks workspace resource automation  
- Glue crawler schedule-ek  
