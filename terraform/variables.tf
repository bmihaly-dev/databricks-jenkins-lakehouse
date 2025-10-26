

variable "aws_region" { type = string }
variable "project" { type = string }
variable "environment" { type = string }

variable "force_destroy_buckets" {
  type    = bool
  default = false
}

variable "kms_key_arn" {
  type    = string
  default = "" # ha üres, SSE-S3 (AES256)
}

variable "tags" {
  type    = map(string)
  default = {}
}