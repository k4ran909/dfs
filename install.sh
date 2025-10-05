#!/bin/bash
# ==========================================
# Caelestia Shell Dependency Installer
# Works on Arch Linux and derivatives
# ==========================================

set -e

echo "=========================================="
echo "   🚀 Installing Caelestia Shell Dependencies"
echo "=========================================="

# Check for yay
if ! command -v yay &> /dev/null; then
    echo "⚙️  yay not found. Installing yay..."
    sudo pacman -S --needed git base-devel --noconfirm
    git clone https://aur.archlinux.org/yay.git /tmp/yay
    cd /tmp/yay
    makepkg -si --noconfirm
    cd -
else
    echo "✅ yay already installed."
fi

echo "=========================================="
echo "📦 Installing core dependencies..."
echo "=========================================="

sudo pacman -S --needed \
git \
ddcutil \
brightnessctl \
networkmanager \
lm_sensors \
fish \
aubio \
libpipewire \
qt6-declarative \
qt6-base \
glibc \
swappy \
libqalculate \
bash \
cmake \
ninja \
--noconfirm

echo "=========================================="
echo "📦 Installing AUR dependencies..."
echo "=========================================="

yay -S --needed \
quickshell-git \
app2unit \
libcava \
material-symbols-fonts \
ttf-caskaydia-cove-nerd \
--noconfirm

echo "=========================================="
echo "✅ All dependencies installed successfully!"
echo "You can now proceed to install Caelestia Shell."
echo "=========================================="
