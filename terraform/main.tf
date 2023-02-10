terraform {
  backend "s3" {
    key    = "api-gateway-example"
    region = "us-west-2"
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0.0"
    }
    archive = {
      source  = "hashicorp/archive"
      version = "~> 2.2.0"
    }
  }
  required_version = "~> 1.3"
}

provider "aws" {
  region  = var.aws_region
  profile = "main-admin"
}
