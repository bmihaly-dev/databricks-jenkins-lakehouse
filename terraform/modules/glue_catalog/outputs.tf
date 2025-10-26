output "databases" {
  value = {
    bronze = aws_glue_catalog_database.bronze.name
    silver = aws_glue_catalog_database.silver.name
    gold   = aws_glue_catalog_database.gold.name
  }
}
output "crawlers" {
  value = {
    bronze = aws_glue_crawler.bronze.name
    silver = aws_glue_crawler.silver.name
    gold   = aws_glue_crawler.gold.name
  }
}