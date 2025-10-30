variable "role_arn" {
  description = "A Databricks által használt IAM szerepkör ARN-je az S3 eléréséhez"
  type        = string
}

variable "credential_name" {
  description = "A Unity Catalog storage credential neve"
  type        = string
  default     = "sc-lakehouse-dev"
}