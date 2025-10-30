terraform {
  required_providers {
    databricks = {
      source  = "databricks/databricks"
      version = "~> 1.60"
    }
  }
}
resource "databricks_storage_credential" "this" {
  name = var.credential_name

  aws_iam_role {
    role_arn = var.role_arn
  }

  comment = "Storage Credential a lakehouse projekt Databricks S3 hozzáféréséhez"
}