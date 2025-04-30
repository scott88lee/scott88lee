# Fast dock autohide
defaults write com.apple.dock autohide-delay -float 0; defaults write com.apple.dock autohide-time-modifier -int 0; killall Dock

# Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"


# Install Homebrew packages
brew install \
  neovim \
  ripgrep \
  fzf \
  htop \
  wget \
  curl \
  font-iosevka-nerd-font

# Install Homebrew cask packages

# Install Bun
curl -fsSL https://bun.sh/install | bash

