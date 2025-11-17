







locals {
  bronze  = "datalake-${var.base_name}-bronze-${var.account_id}-${var.region}"
  silver  = "datalake-${var.base_name}-silver-${var.account_id}-${var.region}"
  gold    = "datalake-${var.base_name}-gold-${var.account_id}-${var.region}"
  use_kms = var.kms_key_arn != ""
}

# Buckets
resource "aws_s3_bucket" "bronze" {
  bucket        = local.bronze
  force_destroy = var.force_destroy
  tags          = merge(var.tags, { Zone = "bronze" })
}

resource "aws_s3_bucket" "silver" {
  bucket        = local.silver
  force_destroy = var.force_destroy
  tags          = merge(var.tags, { Zone = "silver" })
}

resource "aws_s3_bucket" "gold" {
  bucket        = local.gold
  force_destroy = var.force_destroy
  tags          = merge(var.tags, { Zone = "gold" })
}

# Versioning
resource "aws_s3_bucket_versioning" "bronze" {
  bucket = aws_s3_bucket.bronze.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_versioning" "silver" {
  bucket = aws_s3_bucket.silver.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_versioning" "gold" {
  bucket = aws_s3_bucket.gold.id
  versioning_configuration {
    status = "Enabled"
  }
}

# SSE – KMS vagy AES256 (külön resource-ok)
resource "aws_s3_bucket_server_side_encryption_configuration" "bronze_kms" {
  count  = local.use_kms ? 1 : 0
  bucket = aws_s3_bucket.bronze.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
      kms_master_key_id = var.kms_key_arn
    }
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "bronze_sse" {
  count  = local.use_kms ? 0 : 1
  bucket = aws_s3_bucket.bronze.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "silver_kms" {
  count  = local.use_kms ? 1 : 0
  bucket = aws_s3_bucket.silver.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
      kms_master_key_id = var.kms_key_arn
    }
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "silver_sse" {
  count  = local.use_kms ? 0 : 1
  bucket = aws_s3_bucket.silver.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "gold_kms" {
  count  = local.use_kms ? 1 : 0
  bucket = aws_s3_bucket.gold.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
      kms_master_key_id = var.kms_key_arn
    }
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "gold_sse" {
  count  = local.use_kms ? 0 : 1
  bucket = aws_s3_bucket.gold.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Public access block
resource "aws_s3_bucket_public_access_block" "bronze" {
  bucket                  = aws_s3_bucket.bronze.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_public_access_block" "silver" {
  bucket                  = aws_s3_bucket.silver.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_public_access_block" "gold" {
  bucket                  = aws_s3_bucket.gold.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Lifecycle – félbehagyott MPU takarítás
resource "aws_s3_bucket_lifecycle_configuration" "bronze" {
  bucket = aws_s3_bucket.bronze.id
  rule {
    id     = "abort-mpu-7d"
    status = "Enabled"
    filter {}
    abort_incomplete_multipart_upload {
      days_after_initiation = 7
    }
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "silver" {
  bucket = aws_s3_bucket.silver.id
  rule {
    id     = "abort-mpu-7d"
    status = "Enabled"
    filter {}
    abort_incomplete_multipart_upload {
      days_after_initiation = 7
    }
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "gold" {
  bucket = aws_s3_bucket.gold.id
  rule {
    id     = "abort-mpu-7d"
    status = "Enabled"
    filter {}
    abort_incomplete_multipart_upload {
      days_after_initiation = 7
    }
  }
}

# Bucket policy-k – JSON
resource "aws_s3_bucket_policy" "bronze" {
  bucket = aws_s3_bucket.bronze.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid       = "DenyInsecureTransport",
        Effect    = "Deny",
        Principal = "*",
        Action    = "s3:*",
        Resource  = [aws_s3_bucket.bronze.arn, "${aws_s3_bucket.bronze.arn}/*"],
        Condition = { Bool = { "aws:SecureTransport" = "false" } }
      },
     
    ]
  })
}

resource "aws_s3_bucket_policy" "silver" {
  bucket = aws_s3_bucket.silver.id
  policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [
      {
        Sid       = "DenyInsecureTransport"
        Effect    = "Deny"
        Principal = "*"
        Action    = "s3:*"
        Resource  = [
          "arn:aws:s3:::${aws_s3_bucket.silver.bucket}",
          "arn:aws:s3:::${aws_s3_bucket.silver.bucket}/*"
        ]
        Condition = {
          Bool = { "aws:SecureTransport" = "false" }
        }
      }
    ]
  })
}

resource "aws_s3_bucket_policy" "gold" {
  bucket = aws_s3_bucket.gold.id
  policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [
      {
        Sid       = "DenyInsecureTransport"
        Effect    = "Deny"
        Principal = "*"
        Action    = "s3:*"
        Resource  = [
          "arn:aws:s3:::${aws_s3_bucket.gold.bucket}",
          "arn:aws:s3:::${aws_s3_bucket.gold.bucket}/*"
        ]
        Condition = {
          Bool = { "aws:SecureTransport" = "false" }
        }
      }
    ]
  })
}