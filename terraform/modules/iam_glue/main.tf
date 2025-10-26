locals { use_kms = var.kms_key_arn != "" }

resource "aws_iam_role" "glue" {
  name = var.role_name
  assume_role_policy = jsonencode({
    Version   = "2012-10-17",
    Statement = [{ Effect = "Allow", Principal = { Service = "glue.amazonaws.com" }, Action = "sts:AssumeRole" }]
  })
  tags = var.tags
}

resource "aws_iam_policy" "glue_access" {
  name = "${var.role_name}-access"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      { Sid = "ListBuckets", Effect = "Allow", Action = ["s3:ListBucket"], Resource = [var.bronze_arn, var.silver_arn, var.gold_arn] },
      { Sid = "GetObjects", Effect = "Allow", Action = ["s3:GetObject", "s3:GetObjectVersion"],
      Resource = ["${var.bronze_arn}/*", "${var.silver_arn}/*", "${var.gold_arn}/*"] },
      { Sid = "GlueCatalogCRUD", Effect = "Allow", Action = [
        "glue:CreateDatabase", "glue:UpdateDatabase", "glue:DeleteDatabase",
        "glue:CreateTable", "glue:UpdateTable", "glue:DeleteTable",
        "glue:GetDatabase", "glue:GetDatabases", "glue:GetTable", "glue:GetTables",
        "glue:CreateCrawler", "glue:UpdateCrawler", "glue:DeleteCrawler",
        "glue:StartCrawler", "glue:GetCrawler", "glue:GetCrawlers"
      ], Resource = "*" }
  ] })
}

resource "aws_iam_role_policy_attachment" "attach" {
  role       = aws_iam_role.glue.name
  policy_arn = aws_iam_policy.glue_access.arn
}