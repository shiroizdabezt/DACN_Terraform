terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }

  # backend "s3" {
  #   bucket = "your-unique-bucket-name"
  #   key    = "path/to/terraform.tfstate"
  #   region = "us-east-2"  # Đảm bảo vùng khớp với bucket
  # }
}

provider "aws" {
  region     = "us-east-2"
}

# Tạo S3 bucket
resource "aws_s3_bucket" "mybucket" {
  bucket = "ec2mytfstate"
  acl    = "private"

  tags = {
    Name = "My bucket"
  }
}

# Kích hoạt versioning cho S3 bucket
resource "aws_s3_bucket_versioning" "mybucket_versioning" {
  bucket = aws_s3_bucket.mybucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

# terraform {
#   backend "s3" {
#     bucket = "ec2mytfstate"
#     key    = "state/terraform.tfstate"
#     region = "us-east-2"  # Đảm bảo vùng khớp với bucket
#   }
# }

# # Tạo S3 bucket ở vùng chính xác
# resource "aws_s3_bucket" "tf_state_bucket" {
#   bucket = "your-unique-bucket-name"
#   acl    = "private"
  
#   versioning {
#     enabled = true
#   }

#   tags = {
#     Name = "Terraform State Bucket"
#     Environment = "Development"
#   }
# }
