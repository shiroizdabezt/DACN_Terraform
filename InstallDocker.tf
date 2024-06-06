resource "null_resource" "provisioner" {
  connection {
    agent       = "false"
    type        = "ssh"
    user        = "ubuntu"
    private_key = tls_private_key.mykey1.private_key_pem
    host        = aws_instance.public_instance.public_ip
  }
  
  provisioner "Caddyfile" {    
    source      = "Caddyfile"   
    destination = "/etc/caddy/Caddyfile"
    }  

  provisioner "Install_Package" {    
    source      = "Install.sh"   
    destination = "/tmp/Install.sh"
    }  

  provisioner "remote-exec" {    
    inline = [
        "chmod +x /tmp/Install.sh", 
         "/tmp/Install.sh args",
         "sudo systemctl start caddy",] 
  } 
}