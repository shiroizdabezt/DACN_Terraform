sudo echo -e "admin.tuilalinh.id.vn\n\nreverse_proxy :8080 " | sudo tee /etc/caddy/Caddyfile
sudo systemctl start caddy
sudo systemctl restart caddy