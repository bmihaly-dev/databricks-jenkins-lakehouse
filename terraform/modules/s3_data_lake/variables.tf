variable "base_name" { type = string }
variable "account_id" { type = string }
variable "region" { type = string }
variable "force_destroy" { type = bool }
variable "kms_key_arn" { type = string } # üres = AES256
variable "tags" { type = map(string) }