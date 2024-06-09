terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  #   backend "s3" {
  #     bucket = "devops-fullstack-20241-terraform-state"
  #     key = "terraform-${var.env}.tfstate"
  #     region = "us-east-1"
  #     profile = "dev"
  #   }
  backend "s3" {

  }
}

provider "aws" {
  region  = "us-east-1"
}