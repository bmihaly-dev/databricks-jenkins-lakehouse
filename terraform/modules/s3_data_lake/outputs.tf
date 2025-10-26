output "bronze_bucket" { value = aws_s3_bucket.bronze.bucket }
output "silver_bucket" { value = aws_s3_bucket.silver.bucket }
output "gold_bucket" { value = aws_s3_bucket.gold.bucket }
output "bronze_arn" { value = aws_s3_bucket.bronze.arn }
output "silver_arn" { value = aws_s3_bucket.silver.arn }
output "gold_arn" { value = aws_s3_bucket.gold.arn }