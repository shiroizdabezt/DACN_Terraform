terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

resource "aws_s3_bucket" "bucket" {
  bucket = "my_bucket_tfstate"

  tags = {
    Name = "My bucket"
  }
}

resource "aws_s3_object" "object" {
  bucket = "my_bucket_tfstate"
  key    = "state/terraform.tfstate"
}

provider "aws" {
  region     = "us-east-1"
}