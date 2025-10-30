terraform {
  required_version = ">= 1.6.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.40"
    }
    databricks = {
      source  = "databricks/databricks"
      version = "~> 1.60"
    }
  }
}
provider "aws" {
  region = var.aws_region
}
data "aws_caller_identity" "current" {}