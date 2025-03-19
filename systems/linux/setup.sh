#!/bin/bash

set -e  # Exit on error
source helpers.sh  # Load helper functions

log "Starting system setup..."
sudo apt update && sudo apt upgrade -y

# Prompt for Git
read -p "Do you want to install and configure Git? (y/n): " git_choice
if [[ "$git_choice" =~ ^[Yy]$ ]]; then
    ./installs/git.sh
else
    log "Skipping Git setup."
fi

# Prompt for Node.js
read -p "Do you want to install Node.js? (y/n): " node_choice
if [[ "$node_choice" =~ ^[Yy]$ ]]; then
    ./installs/node.sh
else
    log "Skipping Node.js setup."
fi

# Prompt for Neovim
read -p "Do you want to install Neovim and configure it? (y/n): " nvim_choice
if [[ "$nvim_choice" =~ ^[Yy]$ ]]; then
    ./installs/nvim.sh
else
    log "Skipping Neovim setup."
fi

# Prompt for Tmux
read -p "Do you want to install Tmux? (y/n): " tmux_choice
if [[ "$tmux_choice" =~ ^[Yy]$ ]]; then
    ./installs/tmux.sh
else
    log "Skipping Tmux setup."
fi

# Prompt for Server Setup
read -p "Do you want to install Server Tools? (y/n): " server_choice
if [[ "$server_choice" =~ ^[Yy]$ ]]; then
    ./installs/server.sh
else
    log "Skipping Server setup."
fi

log "Setup complete!"
