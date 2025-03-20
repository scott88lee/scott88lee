# Fast dock autohide
defaults write com.apple.dock autohide-delay -float 0; defaults write com.apple.dock autohide-time-modifier -int 0; killall Dock

# Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Download all the links above to the Downloads folder
cd ~/Downloads
curl -O https://nodejs.org/dist/v22.14.0/node-v22.14.0.pkg
curl -O https://ollama.com/download/Ollama-darwin.zip
curl -O https://dl.google.com/chrome/mac/universal/stable/GGRO/googlechrome.dmg
curl -O https://vscode.download.prss.microsoft.com/dbazure/download/stable/ddc367ed5c8936efe395cffeec279b04ffd7db78/VSCode-darwin-arm64.zip
curl -O https://downloads.mongodb.com/compass/mongodb-compass-1.45.4-darwin-arm64.dmg
curl -O https://download.scdn.co/SpotifyInstaller.zip
curl -O https://downloads.eggerapps.at/postico/postico-9702.dmg