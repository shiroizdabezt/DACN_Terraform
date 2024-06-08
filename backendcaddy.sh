sudo echo -e "api.tuilalinh.id.vn\n\nreverse_proxy :4000 " | sudo tee /etc/caddy/Caddyfile
sudo systemctl start caddy