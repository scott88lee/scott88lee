#!/bin/bash

log_file="setup.log"
echo "Setup started at $(date)" > "$log_file"

log() {
    echo "$1"
    echo "$1" >> "$log_file"
}

download() {
    url=$1
    dest=$2
    log "Downloading $url..."
    if wget -q --show-progress "$url" -O "$dest"; then
        log "Downloaded $dest successfully."
        return 0
    else
        log "Failed to download $url. Skipping..."
        return 1
    fi
}
