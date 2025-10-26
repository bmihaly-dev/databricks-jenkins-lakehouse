variable "base_name" { type = string }
variable "bronze_bucket" { type = string }
variable "silver_bucket" { type = string }
variable "gold_bucket" { type = string }
variable "glue_role_arn" { type = string }
variable "tags" { type = map(string) }