#!/bin/bash

source helpers.sh  # Load helper functions

# Prompt for Node.js version, default to 24 if not provided
read -p "Enter the Node.js version you want to install (default is 24): " node_version
node_version=${node_version:-24}  # Use 24 if no version is provided

# Check if Node.js is already installed
if command -v node &>/dev/null; then
    installed_version=$(node -v | cut -d'v' -f2 | cut -d'.' -f1)  # Extract major version
    if [[ "$installed_version" == "$node_version" ]]; then
        log "Node.js $node_version is already installed. Skipping installation."
        exit 0
    else
        log "Updating Node.js from version $installed_version to $node_version..."
    fi
else
    log "Node.js is not installed. Installing version $node_version..."
fi

# Install Node.js
curl -sL "https://deb.nodesource.com/setup_$node_version.x" | sudo -E bash -
sudo apt-get install -y nodejs

# Verify Installation
if command -v node &>/dev/null && command -v npm &>/dev/null; then
    log "Node.js $(node -v) and npm $(npm -v) installed successfully."
else
    log "Node.js installation failed."
    exit 1
fi

# Install global npm packages
log "Installing useful global npm packages..."
sudo npm install -g nodemon ngrok pm2

log "Node.js, ngrok, nodemon, pm2, setup complete."
