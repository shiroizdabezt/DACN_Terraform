sudo echo -e "tuilalinh.id.vn\n\nreverse_proxy :3000 " | sudo tee /etc/caddy/Caddyfile
sudo systemctl start caddy
sudo systemctl restart caddy