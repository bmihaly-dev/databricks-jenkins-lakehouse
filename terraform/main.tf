locals {
  base_name  = "${var.project}-${var.environment}"
  account_id = data.aws_caller_identity.current.account_id
  use_kms    = var.kms_key_arn != ""
  common_tags = merge({
    Project = var.project, Environment = var.environment, ManagedBy = "terraform"
  }, var.tags)
}

module "s3_data_lake" {
  source        = "./modules/s3_data_lake"
  base_name     = local.base_name
  account_id    = local.account_id
  region        = var.aws_region
  force_destroy = var.force_destroy_buckets
  kms_key_arn   = var.kms_key_arn
  tags          = local.common_tags
}

module "iam_glue" {
  source      = "./modules/iam_glue"
  role_name   = "${local.base_name}-glue-crawler-role"
  bronze_arn  = module.s3_data_lake.bronze_arn
  silver_arn  = module.s3_data_lake.silver_arn
  gold_arn    = module.s3_data_lake.gold_arn
  kms_key_arn = var.kms_key_arn
  tags        = local.common_tags
}

module "iam_databricks" {
  source      = "./modules/iam_databricks"
  role_name   = "${local.base_name}-databricks-data-role"
  bronze_arn  = module.s3_data_lake.bronze_arn
  silver_arn  = module.s3_data_lake.silver_arn
  gold_arn    = module.s3_data_lake.gold_arn
  kms_key_arn = var.kms_key_arn
  tags        = local.common_tags
}

module "glue_catalog" {
  source        = "./modules/glue_catalog"
  base_name     = local.base_name
  bronze_bucket = module.s3_data_lake.bronze_bucket
  silver_bucket = module.s3_data_lake.silver_bucket
  gold_bucket   = module.s3_data_lake.gold_bucket
  glue_role_arn = module.iam_glue.role_arn
  tags          = local.common_tags
}