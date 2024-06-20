terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region     = "us-east-1"
}

# resource "aws_s3_bucket" "bucket" {
#   bucket = "mybucket"

#   region = "us-east-1"

#   tags = {
#     Name = "My bucket"
#   }
# }

# resource "aws_s3_bucket_object" "file" {
#   bucket = aws_s3_bucket.bucket.id
#   key    = "state/terraform.tfstate"
# }


terraform {
  backend "s3" {
    bucket = "your-unique-bucket-name"
    key    = "path/to/terraform.tfstate"
    region = "us-east-1"  # Đảm bảo vùng khớp với bucket
  }
}

# Tạo S3 bucket ở vùng chính xác
resource "aws_s3_bucket" "tf_state_bucket" {
  bucket = "your-unique-bucket-name"
  acl    = "private"
  
  versioning {
    enabled = true
  }

  tags = {
    Name = "Terraform State Bucket"
    Environment = "Development"
  }
}
