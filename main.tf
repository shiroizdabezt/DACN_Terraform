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

// To Generate Private Key
resource "tls_private_key" "mykey1" {
  algorithm = "RSA"
}

// Create Key Pair for Connecting EC2 via SSH
resource "aws_key_pair" "key_pair" {
  key_name   = "mykey"
  public_key = tls_private_key.mykey1.public_key_openssh
  depends_on = [
    tls_private_key.mykey1
  ]
} 

# Create a security group
resource "aws_security_group" "sg_ec2" {
  name        = "sg_ec2"
  description = "Security group for EC2"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "http"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "ssh"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "https"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "public_instance" {
  ami                    = "ami-0e001c9271cf7f3b9"
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.key_pair.key_name
  vpc_security_group_ids = [aws_security_group.sg_ec2.id]


  tags = {
    Name = "AINUizdabezt"
  }

  root_block_device {
    volume_size = 30
    volume_type = "gp2"
  }
}

resource "aws_eip" "public_ip" {
  vpc = true
  instance = aws_instance.public_instance.id
  depends_on = [
    aws_instance.public_instance
  ]
}

output "elastic_ip_public" {
  value = aws_eip.public_ip.public_ip
}