#!/bin/bash
# Caelestia Shell Installer for Arch Linux
# Run as a normal user (not root)

echo "Updating system..."
sudo pacman -Syu --noconfirm

echo "Installing essential build tools and dependencies..."
sudo pacman -S --needed base-devel git cmake ninja \
qt6-base qt6-declarative qt6-multimedia qt6-svg qt6-quickcontrols2 qt6-wayland \
wayland-protocols hyprland --noconfirm

# Install yay (AUR helper) if not present
if ! command -v yay &> /dev/null
then
    echo "Installing yay (AUR helper)..."
    cd /tmp
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si --noconfirm
else
    echo "yay already installed."
fi

# Install Caelestia Shell from AUR
echo "Installing Caelestia Shell..."
yay -S --noconfirm caelestia-shell-git

# Create configuration directory
echo "Setting up Caelestia Shell configs..."
mkdir -p ~/.config/caelestia

# Optional: download example configs
echo "Downloading example configs..."
git clone https://github.com/caelestia-dots/shell.git /tmp/caelestia-shell-temp
cp -r /tmp/caelestia-shell-temp/config/* ~/.config/caelestia/
rm -rf /tmp/caelestia-shell-temp

# Suggest autostart entry for Hyprland
echo "To autostart Caelestia Shell with Hyprland, add the following to ~/.config/hypr/hyprland.conf:"
echo "  exec-once = caelestia shell"

echo "Installation complete! You can now run Caelestia Shell with:"
echo "  caelestia shell"
