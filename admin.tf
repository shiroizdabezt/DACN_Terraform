# Create a security group
resource "aws_security_group" "sg_admin" {
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

resource "aws_instance" "admin" {
  ami                    = "ami-0e001c9271cf7f3b9"
  instance_type          = "t2.micro"
  key_name = aws_key_pair.deployer.key_name
  vpc_security_group_ids = [aws_security_group.sg_admin.id]

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
    private_key = file("./id_ed25519")
    host        = aws_instance.admin.public_ip
  }

  provisioner "file" {    
    source      = "admin.sh"   
    destination = "/tmp/admin.sh"
    }  

  provisioner "remote-exec" {    
    inline = [
        "chmod +x /tmp/admin.sh", 
         "/tmp/admin.sh args",
         ] 
  } 
  
  provisioner "file" {    
    source      = "admincaddy.sh"   
    destination = "/tmp/admincaddy.sh"
    } 

  provisioner "remote-exec" {    
    inline = [
         "chmod +x /tmp/admincaddy.sh", 
         "/tmp/admincaddy.sh args",] 
  } 

}

resource "aws_eip" "public_ip_admin" {
  vpc = true
  instance = aws_instance.admin.id
  depends_on = [
    aws_instance.admin
  ]
}

output "elastic_ip_public_admin" {
  value = aws_eip.public_ip_admin.public_ip
}