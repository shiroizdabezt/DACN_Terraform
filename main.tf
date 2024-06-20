# Create a security group
resource "aws_security_group" "sg_frontend" {
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

resource "aws_instance" "frontend" {
  ami                    = "ami-0f30a9c3a48f3fa79"
  instance_type          = "t2.micro"
  key_name = aws_key_pair.deployer.key_name
  vpc_security_group_ids = [aws_security_group.sg_frontend.id]

  tags = {
    Name =""
  }

  depends_on = [ 
    aws_key_pair.deployer
   ]

  root_block_device {
    volume_size = 30
    volume_type = "gp2"
  }

  

  connection {
    agent       = "false"
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("./id_ed25519")
    host        = aws_instance.frontend.public_ip
  }

  provisioner "file" {    
    source      = "frontend.sh"   
    destination = "/tmp/frontend.sh"
    }  

  provisioner "remote-exec" {    
    inline = [
        "chmod +x /tmp/frontend.sh", 
         "/tmp/frontend.sh args",
         ] 
  } 
  
  provisioner "file" {    
    source      = "InstallCaddy.sh"   
    destination = "/tmp/InstallCaddy.sh"
    } 

  provisioner "remote-exec" {    
    inline = [
         "chmod +x /tmp/InstallCaddy.sh", 
         "/tmp/InstallCaddy.sh args",] 
  } 

}

resource "aws_eip" "public_ip_frontend" {
  vpc = true
  instance = aws_instance.frontend.id
  depends_on = [
    aws_instance.frontend
  ]
}

output "elastic_ip_public_frontend" {
  value = aws_eip.public_ip_frontend.public_ip
}