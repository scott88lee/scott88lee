#!/bin/bash

source helpers.sh  # Load helper functions

# Check if Git is already installed
if command -v git &>/dev/null; then
    log "Git is already installed. Version: $(git --version)"
else
    log "Installing Git..."
    sudo apt install -y git
    log "Git installation complete."
fi

# Configuring Git
log "Configuring Git..."
read -p "Enter your Git username: " git_username
read -p "Enter your Git email: " git_email

git config --global user.name "$git_username"
git config --global user.email "$git_email"
git config --global push.default simple
git config --global credential.helper store
git config --global pull.rebase false
log "Git setup complete!"