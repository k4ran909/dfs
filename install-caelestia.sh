#!/bin/bash
# Fish-friendly Caelestia Shell installer for Arch Linux
# Run as root

# ==== CONFIG ====
USERNAME="karan"   # <-- replace with your normal user
USER_HOME="/home/$USERNAME"

# ==== STEP 1: Update system ====
echo "Updating system..."
pacman -Syu --noconfirm

# ==== STEP 2: Install dependencies ====
echo "Installing essential build tools and dependencies..."
pacman -S --needed base-devel git cmake ninja \
qt6-base qt6-declarative qt6-multimedia qt6-svg qt6-quickcontrols2 qt6-wayland \
wayland-protocols hyprland fish --noconfirm

# ==== STEP 3: Install yay (AUR helper) ====
if ! command -v yay &> /dev/null
then
    echo "Installing yay..."
    cd /tmp
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si --noconfirm
else
    echo "yay already installed."
fi

# ==== STEP 4: Install Caelestia Shell ====
echo "Installing Caelestia Shell..."
yay -S --noconfirm caelestia-shell-git

# ==== STEP 5: Setup config for normal user ====
echo "Setting up Caelestia Shell configs for user $USERNAME..."
mkdir -p "$USER_HOME/.config/caelestia"
git clone https://github.com/caelestia-dots/shell.git /tmp/caelestia-shell-temp
cp -r /tmp/caelestia-shell-temp/config/* "$USER_HOME/.config/caelestia/"
chown -R $USERNAME:$USERNAME "$USER_HOME/.config/caelestia"
rm -rf /tmp/caelestia-shell-temp

# ==== STEP 6: Ensure Caelestia is in fish PATH ====
echo "Adding Caelestia to Fish PATH for $USERNAME..."
su - $USERNAME -c "set -U fish_user_paths /usr/bin \$fish_user_paths"

# ==== STEP 7: Autostart instruction ====
echo ""
echo "Installation complete!"
echo "Switch to your normal user:"
echo "  su - $USERNAME"
echo "Run the shell with:"
echo "  caelestia shell"
echo ""
echo "To autostart with Hyprland, add the following line to ~/.config/hypr/hyprland.conf:"
echo "  exec-once = caelestia shell"
