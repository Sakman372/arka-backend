# Terraform skeleton - completa variables y módulos según tu VPC
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
# Añade recursos: RDS, ECR, ECS, SQS, SNS, S3, Lambda...
