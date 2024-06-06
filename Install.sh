sudo apt update
sudo apt install docker.io -y
docker --version
docker pull pokilee10/frontend:latest
docker pull pokilee10/backend:latest
docker pull pokilee10/admin:latest
docker run -d -p 3000:3000 pokilee10/frontend
docker run -d -p 4000:4000 pokilee10/backend
docker run -d -p 8080:8080 pokilee10/admin
sudo apt install Caddy