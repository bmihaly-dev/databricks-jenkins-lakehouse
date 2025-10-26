locals { use_kms = var.kms_key_arn != "" }

resource "aws_iam_role" "dbx" {
  name = var.role_name
  assume_role_policy = jsonencode({
    Version   = "2012-10-17",
    Statement = [{ Effect = "Allow", Principal = { Service = "ec2.amazonaws.com" }, Action = "sts:AssumeRole" }]
  })
  tags = var.tags
}

resource "aws_iam_policy" "rw_s3" {
  name = "${var.role_name}-rw-s3"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      { Sid = "ListBuckets", Effect = "Allow", Action = ["s3:ListBucket"], Resource = [var.bronze_arn, var.silver_arn, var.gold_arn] },
      { Sid = "RWObjects", Effect = "Allow", Action = [
        "s3:GetObject", "s3:GetObjectVersion", "s3:PutObject", "s3:DeleteObject",
        "s3:AbortMultipartUpload", "s3:ListBucketMultipartUploads", "s3:ListBucketVersions"
      ], Resource = ["${var.bronze_arn}/*", "${var.silver_arn}/*", "${var.gold_arn}/*"] }
  ] })
}
resource "aws_iam_role_policy_attachment" "attach_rw" {
  role       = aws_iam_role.dbx.name
  policy_arn = aws_iam_policy.rw_s3.arn
}

resource "aws_iam_policy" "kms" {
  count = local.use_kms ? 1 : 0
  name  = "${var.role_name}-kms"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{ Sid = "UseKMSKey", Effect = "Allow",
      Action = ["kms:Encrypt", "kms:Decrypt", "kms:GenerateDataKey", "kms:DescribeKey"],
    Resource = var.kms_key_arn }]
  })
}
resource "aws_iam_role_policy_attachment" "attach_kms" {
  count      = local.use_kms ? 1 : 0
  role       = aws_iam_role.dbx.name
  policy_arn = aws_iam_policy.kms[0].arn
}