#!/bin/bash
# ==================================================
# 🌌 Caelestia Shell Manual Installation Script
# Works on Arch Linux and derivatives
# ==================================================

set -e

echo "=============================================="
echo "🚀 Starting Caelestia Shell installation..."
echo "=============================================="

# Ensure dependencies are present
echo "📦 Checking for dependencies..."
sudo pacman -S --needed git cmake ninja qt6-base qt6-declarative fish bash --noconfirm

# Make sure yay exists for AUR packages (optional)
if ! command -v yay &> /dev/null; then
    echo "⚙️  yay not found, installing..."
    sudo pacman -S --needed git base-devel --noconfirm
    git clone https://aur.archlinux.org/yay.git /tmp/yay
    cd /tmp/yay
    makepkg -si --noconfirm
    cd -
else
    echo "✅ yay already installed."
fi

# Optional AUR dependencies
yay -S --needed quickshell-git app2unit libcava material-symbols-fonts ttf-caskaydia-cove-nerd --noconfirm

# Set config directory
CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/quickshell"
mkdir -p "$CONFIG_DIR"
cd "$CONFIG_DIR"

# Clone Caelestia Shell repo
if [ ! -d "caelestia" ]; then
    echo "📥 Cloning Caelestia Shell repository..."
    git clone https://github.com/caelestia-dots/shell.git caelestia
else
    echo "🔄 Repository already exists, pulling latest changes..."
    cd caelestia && git pull origin main && cd ..
fi

# Build and install
echo "🔧 Building Caelestia Shell..."
cd caelestia
cmake -B build -G Ninja -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/
cmake --build build
sudo cmake --install build

# Ensure caelestia CLI is in PATH
if ! command -v caelestia &> /dev/null; then
    echo "⚠️  Warning: 'caelestia' command not found. Make sure the CLI is enabled."
else
    echo "✅ Caelestia Shell installed successfully!"
fi

# Create default config if missing
CAEL_CONF="$HOME/.config/caelestia/shell.json"
if [ ! -f "$CAEL_CONF" ]; then
    echo "🛠️  Creating default config at $CAEL_CONF"
    mkdir -p "$(dirname "$CAEL_CONF")"
    cat > "$CAEL_CONF" <<EOF
{
  "shell": {
    "theme": "default",
    "autostart": true
  }
}
EOF
fi

echo "=============================================="
echo "🌌 Installation complete!"
echo ""
echo "To start Caelestia Shell manually, run:"
echo "  caelestia shell"
echo ""
echo "Or add this to your Hyprland config:"
echo "  exec-once = caelestia shell"
echo "=============================================="
