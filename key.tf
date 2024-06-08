// To Generate Private Key
resource "tls_private_key" "mykey1" {
  algorithm = "RSA"
}

// Create Key Pair for Connecting EC2 via SSH
resource "aws_key_pair" "key_pair" {
  public_key = tls_private_key.mykey1.public_key_openssh
  depends_on = [
    tls_private_key.mykey1
  ]
} 

// Save PEM file locally
resource "local_file" "private_key" {
  content  = tls_private_key.mykey1.private_key_pem
  filename = "mykeyssh.pem"
}