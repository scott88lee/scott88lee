#!/bin/bash

source helpers.sh  # Load helper functions

NVIM_URL="https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz"

# Check if Neovim is already installed
if command -v nvim &>/dev/null; then
    log "Neovim is already installed. Skipping installation."
    exit 0
fi

log "Downloading Neovim..."
if wget -q "$NVIM_URL" -O nvim-linux-x86_64.tar.gz; then
    log "Download successful."
else
    log "Download failed. Skipping installation."
    exit 1
fi

# Extract and install Neovim
tar -xzf nvim-linux-x86_64.tar.gz
sudo cp -r nvim-linux-x86_64/bin/* /usr/bin/
sudo cp -r nvim-linux-x86_64/lib/* /usr/lib/
sudo cp -r nvim-linux-x86_64/share/* /usr/share/

# Download init.vim configuration
log "Setting up Neovim configuration..."
mkdir -p ~/.config/nvim/
wget -q -O ~/.config/nvim/init.vim https://raw.githubusercontent.com/scott88lee/scott88lee/main/configs/nvim/init.vim

# Install vim-plug for plugin management
log "Installing vim-plug..."
curl -sfLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
     https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Clean up installation files
rm -rf nvim-linux-x86_64
rm nvim-linux-x86_64.tar.gz

# Verify installation
if command -v nvim &>/dev/null; then
    log "Neovim installed successfully."
else
    log "Neovim installation failed."
    exit 1
fi

log "Neovim setup complete."
