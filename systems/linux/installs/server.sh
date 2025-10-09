#!/bin/bash

# ============================================
# Interactive Prompts
# ============================================

echo "================================================"
echo "  Server Setup - Domain & Nginx Configuration"
echo "================================================"
echo ""

# Prompt for domain name
read -p "Enter your domain name (e.g., example.com or www.example.com): " DOMAIN_NAME
if [ -z "$DOMAIN_NAME" ]; then
    echo "Error: Domain name is required"
    exit 1
fi

# Prompt for application port
read -p "Enter the local port your application runs on (e.g., 3000, 8080): " APP_PORT
if [ -z "$APP_PORT" ]; then
    echo "Error: Application port is required"
    exit 1
fi

# Validate port is a number
if ! [[ "$APP_PORT" =~ ^[0-9]+$ ]]; then
    echo "Error: Port must be a number"
    exit 1
fi

echo ""
echo "Configuration Summary:"
echo "  Domain: $DOMAIN_NAME"
echo "  Application Port: $APP_PORT"
echo ""
read -p "Proceed with this configuration? (y/n): " CONFIRM
if [[ ! "$CONFIRM" =~ ^[Yy]$ ]]; then
    echo "Setup cancelled"
    exit 0
fi

echo ""
echo "Starting server setup..."
echo ""

# ============================================
# Install Nginx
# ============================================

if command -v nginx &> /dev/null; then
    log "Nginx is already installed (version: $(nginx -v 2>&1 | cut -d'/' -f2))"
else
    log "Installing Nginx"
    sudo apt update
    sudo apt install nginx -y
fi

# Install UFW if not present
if ! command -v ufw &> /dev/null; then
    sudo apt install ufw -y
fi

# Configure firewall
log "Configuring firewall"
sudo ufw allow 'Nginx Full'
sudo ufw allow OpenSSH

# Start and enable Nginx
sudo systemctl start nginx 2>/dev/null || true
sudo systemctl enable nginx

echo "Nginx is running on port 80"
echo "Please verify your domain DNS is pointing to this server's IP address"
echo "You can check by visiting http://$DOMAIN_NAME"
echo ""
read -p "Press Enter once you've verified the domain is resolving correctly..."

# ============================================
# Install Certbot (Let's Encrypt)
# ============================================

if command -v certbot &> /dev/null; then
    log "Certbot is already installed (version: $(certbot --version 2>&1 | cut -d' ' -f2))"
else
    log "Installing Certbot for SSL certificates"
    sudo snap install core 2>/dev/null || true
    sudo snap refresh core
    sudo apt remove certbot -y 2>/dev/null || true
    sudo snap install --classic certbot
    sudo ln -sf /snap/bin/certbot /usr/bin/certbot
fi

# ============================================
# Obtain SSL Certificate
# ============================================

# Check if certificate already exists
if sudo certbot certificates 2>/dev/null | grep -q "$DOMAIN_NAME"; then
    log "SSL certificate already exists for $DOMAIN_NAME"
    read -p "Do you want to renew/recreate the certificate? (y/n): " RENEW_CERT
    if [[ ! "$RENEW_CERT" =~ ^[Yy]$ ]]; then
        log "Skipping SSL certificate generation"
    else
        log "Renewing SSL certificate for $DOMAIN_NAME"
        read -p "Enter your email for SSL certificate notifications: " SSL_EMAIL
        
        if [ -z "$SSL_EMAIL" ]; then
            sudo certbot --nginx -d "$DOMAIN_NAME" --register-unsafely-without-email --agree-tos --non-interactive --force-renewal
        else
            sudo certbot --nginx -d "$DOMAIN_NAME" --email "$SSL_EMAIL" --agree-tos --non-interactive --force-renewal
        fi
    fi
else
    log "Obtaining SSL certificate for $DOMAIN_NAME"
    read -p "Enter your email for SSL certificate notifications: " SSL_EMAIL

    if [ -z "$SSL_EMAIL" ]; then
        echo "Warning: No email provided. You won't receive renewal notifications."
        sudo certbot --nginx -d "$DOMAIN_NAME" --register-unsafely-without-email --agree-tos --non-interactive
    else
        sudo certbot --nginx -d "$DOMAIN_NAME" --email "$SSL_EMAIL" --agree-tos --non-interactive
    fi
fi

# ============================================
# Configure Nginx with Reverse Proxy
# ============================================

log "Configuring Nginx reverse proxy"

# Use domain-specific config file instead of default
config_file="/etc/nginx/sites-available/$DOMAIN_NAME"
enabled_link="/etc/nginx/sites-enabled/$DOMAIN_NAME"

# Check if config already exists
if [ -f "$config_file" ]; then
    echo "Configuration file already exists for $DOMAIN_NAME"
    read -p "Do you want to overwrite it? (y/n): " OVERWRITE_CONFIG
    if [[ ! "$OVERWRITE_CONFIG" =~ ^[Yy]$ ]]; then
        log "Skipping Nginx configuration"
        echo "Existing configuration preserved at: $config_file"
        exit 0
    fi
    # Create a backup before overwriting
    sudo cp "$config_file" "$config_file.backup.$(date +%Y%m%d_%H%M%S)"
    echo "Backup created: $config_file.backup.$(date +%Y%m%d_%H%M%S)"
fi

# Write the configuration
cat <<EOT | sudo tee "$config_file" > /dev/null
# HTTP - Redirect to HTTPS
server {
    listen 80;
    server_name $DOMAIN_NAME;
    return 301 https://\$host\$request_uri;
}

# HTTPS - Main Server Block
server {
    listen 443 ssl;
    server_name $DOMAIN_NAME;

    ssl_certificate /etc/letsencrypt/live/$DOMAIN_NAME/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/$DOMAIN_NAME/privkey.pem;
    
    # SSL Security Settings
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_prefer_server_ciphers on;
    ssl_ciphers 'ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES256-GCM-SHA384';

    # Reverse Proxy to Application
    location / {
        proxy_pass http://localhost:$APP_PORT;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
        
        # WebSocket support (if needed)
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_cache_bypass \$http_upgrade;
    }
}
EOT

# Enable the site by creating symlink
if [ ! -L "$enabled_link" ]; then
    log "Enabling site configuration"
    sudo ln -s "$config_file" "$enabled_link"
else
    log "Site is already enabled"
fi

# Remove default site if it's still enabled (optional - ask user)
if [ -L "/etc/nginx/sites-enabled/default" ]; then
    echo ""
    echo "The default Nginx site is currently enabled."
    read -p "Do you want to disable it? (recommended if this is your only site) (y/n): " DISABLE_DEFAULT
    if [[ "$DISABLE_DEFAULT" =~ ^[Yy]$ ]]; then
        sudo rm /etc/nginx/sites-enabled/default
        log "Default site disabled"
    fi
fi

# ============================================
# Test and Reload Nginx
# ============================================

log "Testing Nginx configuration"
sudo nginx -t

if [ $? -eq 0 ]; then
    log "Nginx configuration valid. Reloading..."
    sudo systemctl reload nginx
    echo ""
    echo "================================================"
    echo "  Server Setup Complete!"
    echo "================================================"
    echo "Domain: https://$DOMAIN_NAME"
    echo "Proxying to: http://localhost:$APP_PORT"
    echo "Config file: $config_file"
    echo ""
    echo "SSL certificate will auto-renew via certbot."
    echo "Test renewal with: sudo certbot renew --dry-run"
    echo ""
    echo "To manage this site:"
    echo "  - Edit config: sudo nano $config_file"
    echo "  - Disable site: sudo rm $enabled_link && sudo systemctl reload nginx"
    echo "  - View logs: sudo tail -f /var/log/nginx/access.log"
    echo "================================================"
else
    echo "ERROR: Nginx configuration test failed!"
    echo "Please check the configuration at $config_file"
    exit 1
fi