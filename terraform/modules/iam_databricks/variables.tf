variable "role_name" { type = string }
variable "bronze_arn" { type = string }
variable "silver_arn" { type = string }
variable "gold_arn" { type = string }
variable "kms_key_arn" { type = string }
variable "tags" { type = map(string) }