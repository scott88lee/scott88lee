# Setup SSL
log "Setup SSL"
sudo snap install core
sudo snap refresh core
sudo apt remove certbot
sudo snap install --classic certbot
sudo ln -s /snap/bin/certbot /usr/bin/certbot
sudo certbot certonly --standalone -d www.example.com --register-unsafely-without-email

log "Setup Nginx"
sudo apt install nginx -y
sudo apt install ufw -y
sudo ufw allow 'Nginx Full'

# Setup Nginx
config_file="/etc/nginx/sites-available/default"

# Create a backup of the original config file
sudo cp "$config_file" "$config_file.backup"

# Write the configuration for mj.samima.link
cat <<EOT | sudo tee -a "$config_file" > /dev/null

server {
    listen 80;
    server_name www.example.com;
    return 301 https://\$host\$request_uri;
}

server {
    listen 443 ssl;
    server_name www.example.com;

    ssl_certificate /etc/letsencrypt/live/www.example.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/www.example.com/privkey.pem;

    location / {
        proxy_pass http://localhost:3000;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }
}
EOT

echo "Testing Nginx Configuration"
sudo nginx -t
#sudo systemctl start nginx

# If the configuration test is successful, reload Nginx
if [ $? -eq 0 ]; then
    echo "Passed. Reloading Nginx"
    sudo systemctl reload nginx
fi