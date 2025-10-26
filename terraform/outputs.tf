output "databricks_role_arn" { value = module.iam_databricks.role_arn }
output "glue_role_arn" { value = module.iam_glue.role_arn }
output "bronze_bucket" { value = module.s3_data_lake.bronze_bucket }
output "silver_bucket" { value = module.s3_data_lake.silver_bucket }
output "gold_bucket" { value = module.s3_data_lake.gold_bucket }