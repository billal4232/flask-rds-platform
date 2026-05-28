terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
backend "s3" {
    bucket         = "limonlab-terraform-state"
    key            = "flask-rds-platform/terraform.tfstate"
    region         = "eu-north-1"
    use_lockfile   = true
    encrypt        = true
    profile        = "limonlab"
  }
}

provider "aws" {
  region = "eu-north-1"
  profile = var.aws_profile
}
#provider "aws" {
 # alias = "us_east_1"
  #region = "us-east-1"
  #profile = var.aws_profile
#}