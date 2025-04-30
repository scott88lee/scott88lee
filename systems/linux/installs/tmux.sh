#!/bin/bash

source helpers.sh  # Load helper functions

# Check if tmux is already installed
if command -v tmux &>/dev/null; then
    log "tmux is already installed. Skipping installation."
else
    log "Installing tmux..."
    sudo apt-get update -y && sudo apt-get install -y tmux

    if command -v tmux &>/dev/null; then
        log "tmux installed successfully."
    else
        log "tmux installation failed."
        exit 1
    fi
fi

# Download tmux configuration file
log "Setting up tmux configuration..."
wget -q -O ~/.tmux.conf https://raw.githubusercontent.com/scott88lee/scott88lee/main/configs/tmux/.tmux.conf

log "tmux setup complete."
