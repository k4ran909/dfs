#!/bin/bash

# install.sh for Caelestia Shell
# Usage: bash install.sh [--global]

set -e

echo "🧱 Installing Caelestia Shell..."

# Step 1: Create config directory
CONFIG_DIR="$HOME/.config/quickshell"
echo "Creating config directory at $CONFIG_DIR..."
mkdir -p "$CONFIG_DIR"

# Step 2: Clone Caelestia shell repository
cd "$CONFIG_DIR"
if [ ! -d "caelestia" ]; then
    echo "Cloning Caelestia shell repository..."
    git clone https://github.com/caelestia-dots/shell.git caelestia
else
    echo "Caelestia folder already exists. Pulling latest changes..."
    cd caelestia
    git pull origin main
fi

# Step 3: List cloned files
echo "Checking cloned files..."
ls -l "$CONFIG_DIR/caelestia"

# Step 4: Optional system-wide symlink
if [[ "$1" == "--global" ]]; then
    echo "Creating system-wide link..."
    sudo mkdir -p /etc/xdg/quickshell
    sudo ln -sf "$CONFIG_DIR/caelestia" /etc/xdg/quickshell/caelestia
fi

# Step 5: Test Caelestia shell
echo "Testing Caelestia shell version..."
if command -v caelestia >/dev/null 2>&1; then
    caelestia --version
else
    echo "Warning: 'caelestia' command not found. Make sure it's in your PATH."
fi

echo "🚀 Installation complete! You can launch it with:"
echo "   caelestia shell"
