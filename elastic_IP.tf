resource "aws_eip" "public_ip" {
  vpc   = true
  instance = aws_instance.public_instance.id
  depends_on = [
    aws_instance.public_instance
  ]
}

output "elastic_ip_public" {
  value = aws_eip.public_ip.public_ip
}