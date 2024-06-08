# Create a security group
resource "aws_security_group" "sg_backend" {
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

resource "aws_instance" "backend" {
  ami                    = "ami-0e001c9271cf7f3b9"
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.key_pair.key_name
  vpc_security_group_ids = [aws_security_group.sg_backend.id]

  tags = {
    Name =""
  }

  root_block_device {
    volume_size = 30
    volume_type = "gp2"
  }

  connection {
    agent       = "false"
    type        = "ssh"
    user        = "ubuntu"
    private_key = tls_private_key.mykey1.private_key_pem
    host        = aws_instance.backend.public_ip
  }

  provisioner "file" {    
    source      = "backend.sh"   
    destination = "/tmp/backend.sh"
    }  

  provisioner "remote-exec" {    
    inline = [
        "chmod +x /tmp/backend.sh", 
         "/tmp/backend.sh args",
         ] 
  } 
  
  provisioner "file" {    
    source      = "backendcaddy.sh"   
    destination = "/tmp/backendcaddy.sh"
    } 

  provisioner "remote-exec" {    
    inline = [
         "chmod +x /tmp/backendcaddy.sh", 
         "/tmp/backendcaddy.sh args",] 
  } 

}

resource "aws_eip" "public_ip_backend" {
  vpc = true
  instance = aws_instance.backend.id
  depends_on = [
    aws_instance.backend
  ]
}

output "elastic_ip_public_backend" {
  value = aws_eip.public_ip_backend.public_ip
}