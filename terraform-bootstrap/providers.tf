terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "local" {}  # bootstrap mindig lokál backenddel fut
}

provider "aws" {
  region = var.aws_region
}