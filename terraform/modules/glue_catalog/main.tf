# Databases
resource "aws_glue_catalog_database" "bronze" { name = "${var.base_name}_bronze" }
resource "aws_glue_catalog_database" "silver" { name = "${var.base_name}_silver" }
resource "aws_glue_catalog_database" "gold" { name = "${var.base_name}_gold" }

# Egységes crawler config
locals {
  crawler_config_json = jsonencode({
    Version       = 1.0,
    CrawlerOutput = { Partitions = { AddOrUpdateBehavior = "InheritFromTable" } },
    Grouping      = { TableGroupingPolicy = "CombineCompatibleSchemas" }
  })
}

# Crawlers
resource "aws_glue_crawler" "bronze" {
  name          = "${var.base_name}-bronze-crawler"
  role          = var.glue_role_arn
  database_name = aws_glue_catalog_database.bronze.name
  s3_target { path = "s3://${var.bronze_bucket}/" }
  configuration = local.crawler_config_json
  tags          = merge(var.tags, { Zone = "bronze" })
}
resource "aws_glue_crawler" "silver" {
  name          = "${var.base_name}-silver-crawler"
  role          = var.glue_role_arn
  database_name = aws_glue_catalog_database.silver.name
  s3_target { path = "s3://${var.silver_bucket}/" }
  configuration = local.crawler_config_json
  tags          = merge(var.tags, { Zone = "silver" })
}
resource "aws_glue_crawler" "gold" {
  name          = "${var.base_name}-gold-crawler"
  role          = var.glue_role_arn
  database_name = aws_glue_catalog_database.gold.name
  s3_target { path = "s3://${var.gold_bucket}/" }
  configuration = local.crawler_config_json
  tags          = merge(var.tags, { Zone = "gold" })
}