output "credential_name" {
  description = "A létrehozott Unity Catalog storage credential neve"
  value       = databricks_storage_credential.this.name
}

output "credential_id" {
  description = "A létrehozott Unity Catalog storage credential ID-ja"
  value       = databricks_storage_credential.this.id
}