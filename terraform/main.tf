# Terraform skeleton - Revisa y personaliza antes de aplicar
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
provider "aws" {
  region = var.aws_region
}
resource "random_id" "bucket_suffix" {
  byte_length = 4
}
resource "aws_s3_bucket" "arka_reports" {
  bucket = "${var.prefix}-arka-reports-${random_id.bucket_suffix.hex}"
  acl    = "private"
}
# Añade módulos: RDS, ECR, ECS, SQS, SNS, Lambda, IAM...
