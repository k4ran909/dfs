#!/bin/bash
# ==========================================================
# 🌌 Caelestia Shell - Manual Installation Script (Arch Linux)
# Based on latest official README
# ==========================================================

set -e

echo "=============================================="
echo "🚀 Installing Caelestia Shell (Manual Build)"
echo "=============================================="

# --- Step 1: Ensure yay (AUR helper) is installed ---
if ! command -v yay &> /dev/null; then
    echo "⚙️  Installing yay..."
    sudo pacman -S --needed git base-devel --noconfirm
    git clone https://aur.archlinux.org/yay.git /tmp/yay
    cd /tmp/yay && makepkg -si --noconfirm && cd -
else
    echo "✅ yay already installed."
fi

# --- Step 2: Install dependencies ---
echo "📦 Installing dependencies..."
sudo pacman -S --needed --noconfirm \
    git \
    ddcutil \
    brightnessctl \
    networkmanager \
    lm_sensors \
    fish \
    aubio \
    libpipewire \
    glibc \
    gcc-libs \
    qt6-base \
    qt6-declarative \
    swappy \
    libqalculate \
    bash \
    cmake \
    ninja

yay -S --needed --noconfirm \
    caelestia-cli \
    quickshell-git \
    app2unit \
    libcava \
    material-symbols-fonts \
    ttf-caskaydia-cove-nerd

# --- Step 3: Clone repository ---
CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/quickshell"
mkdir -p "$CONFIG_DIR"
cd "$CONFIG_DIR"

if [ ! -d "caelestia" ]; then
    echo "📥 Cloning Caelestia Shell repository..."
    git clone https://github.com/caelestia-dots/shell.git caelestia
else
    echo "🔄 Updating existing Caelestia Shell repository..."
    cd caelestia && git pull origin main && cd ..
fi

# --- Step 4: Build & Install ---
cd caelestia
echo "🔧 Building Caelestia Shell..."
cmake -B build -G Ninja -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/
cmake --build build
echo "🧩 Installing Caelestia Shell..."
sudo cmake --install build

# --- Step 5: Ownership fix (optional for local install) ---
sudo chown -R "$USER" "$CONFIG_DIR/caelestia" || true

# --- Step 6: Create default configuration file if missing ---
CAEL_CONF="$HOME/.config/caelestia/shell.json"
if [ ! -f "$CAEL_CONF" ]; then
    echo "🛠️  Creating default config at $CAEL_CONF..."
    mkdir -p "$(dirname "$CAEL_CONF")"
    cat > "$CAEL_CONF" <<EOF
{
  "general": {
    "apps": {
      "terminal": ["foot"],
      "audio": ["pavucontrol"],
      "playback": ["mpv"],
      "explorer": ["thunar"]
    }
  },
  "background": {
    "enabled": true
  },
  "bar": {
    "enabled": true,
    "entries": []
  }
}
EOF
fi

# --- Step 7: Final check ---
echo "=============================================="
if command -v caelestia &> /dev/null; then
    echo "✅ Caelestia Shell installed successfully!"
else
    echo "⚠️  'caelestia' CLI not found — verify PATH or enable the CLI manually."
fi

echo ""
echo "👉 To start the shell manually, run:"
echo "   caelestia shell -d"
echo ""
echo "👉 Or add to Hyprland config:"
echo "   exec-once = caelestia shell"
echo ""
echo "🌈 Wallpapers: Place in ~/Pictures/Wallpapers"
echo "🧍 Profile Picture: ~/.face"
echo ""
echo "🎉 Installation complete!"
echo "=============================================="
