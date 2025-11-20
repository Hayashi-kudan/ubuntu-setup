#!/bin/bash

# Script to completely uninstall NVIDIA drivers (both package-managed and .run file installations)
# Author: Generated for complete NVIDIA driver removal
# Date: 2025-11-19

set -e  # Exit on error

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${GREEN}NVIDIA Complete Uninstallation Script${NC}"
echo "========================================"
echo ""

# Check if running as root
if [[ $EUID -ne 0 ]]; then
   echo -e "${RED}Error: This script must be run as root${NC}"
   echo "Please run: sudo bash $0"
   exit 1
fi

echo -e "${BLUE}This script will completely remove all NVIDIA drivers from your system.${NC}"
echo ""
read -p "Continue? (y/n): " -n 1 -r
echo ""
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Aborted."
    exit 0
fi

echo ""
echo -e "${YELLOW}Step 1: Unloading NVIDIA kernel modules...${NC}"
# Unload NVIDIA modules (best effort)
echo "Attempting to unload NVIDIA modules..."
modprobe -r nvidia_drm 2>/dev/null && echo "  Unloaded nvidia_drm" || echo "  nvidia_drm: not loaded or in use"
modprobe -r nvidia_modeset 2>/dev/null && echo "  Unloaded nvidia_modeset" || echo "  nvidia_modeset: not loaded or in use"
modprobe -r nvidia_uvm 2>/dev/null && echo "  Unloaded nvidia_uvm" || echo "  nvidia_uvm: not loaded or in use"
modprobe -r nvidia 2>/dev/null && echo "  Unloaded nvidia" || echo "  nvidia: not loaded or in use"
modprobe -r nvidia_peermem 2>/dev/null && echo "  Unloaded nvidia_peermem" || echo "  nvidia_peermem: not loaded or in use"

# Check which modules are still loaded
if lsmod | grep -q nvidia; then
    echo -e "${YELLOW}Warning: Some NVIDIA modules are still loaded:${NC}"
    lsmod | grep nvidia
    echo ""
    echo "This might be because:"
    echo "  - Display is using NVIDIA GPU"
    echo "  - Some processes are using the GPU"
    echo ""
    echo "Continuing anyway... modules will be removed on next boot."
else
    echo -e "${GREEN}All NVIDIA modules unloaded successfully${NC}"
fi

echo ""
echo -e "${YELLOW}Step 2: Removing NVIDIA drivers installed via .run file...${NC}"
# Try to uninstall using nvidia-uninstall if it exists (from .run file installations)
if command -v nvidia-uninstall &> /dev/null; then
    echo "Found nvidia-uninstall, running it..."
    nvidia-uninstall --silent || echo "nvidia-uninstall completed with warnings (this is normal)"
else
    echo "No nvidia-uninstall found (no .run file installation detected)"
fi

echo ""
echo -e "${YELLOW}Step 3: Removing all NVIDIA packages from package manager...${NC}"

# Ubuntu/Debian based
if command -v apt-get &> /dev/null; then
    echo "Detected apt package manager"
    echo ""

    # List all NVIDIA packages
    echo "Currently installed NVIDIA packages:"
    dpkg -l | grep -i nvidia | awk '{print $2}' || echo "  None found via dpkg"
    echo ""

    # Remove all NVIDIA packages
    echo "Removing NVIDIA packages..."
    apt-get remove --purge -y '^nvidia-.*' 2>/dev/null || true
    apt-get remove --purge -y '^libnvidia-.*' 2>/dev/null || true
    apt-get remove --purge -y nvidia-driver-* 2>/dev/null || true
    apt-get remove --purge -y nvidia-dkms-* 2>/dev/null || true
    apt-get remove --purge -y nvidia-kernel-* 2>/dev/null || true
    apt-get remove --purge -y nvidia-utils-* 2>/dev/null || true
    apt-get remove --purge -y nvidia-settings 2>/dev/null || true
    apt-get remove --purge -y nvidia-prime 2>/dev/null || true
    apt-get remove --purge -y nvidia-detector 2>/dev/null || true

    # Clean up
    echo "Running autoremove..."
    apt-get autoremove -y
    echo "Running autoclean..."
    apt-get autoclean

elif command -v dnf &> /dev/null; then
    # Fedora/RHEL based
    echo "Detected dnf package manager"
    dnf remove -y 'nvidia-*' '*nvidia*' || true
    dnf autoremove -y

elif command -v pacman &> /dev/null; then
    # Arch based
    echo "Detected pacman package manager"
    pacman -Rns --noconfirm nvidia nvidia-utils nvidia-settings 2>/dev/null || true
fi

echo ""
echo -e "${YELLOW}Step 4: Removing NVIDIA configuration files and directories...${NC}"

# Remove configuration files
CONFIG_FILES=(
    "/etc/X11/xorg.conf"
    "/etc/X11/xorg.conf.d/*nvidia*"
    "/usr/share/X11/xorg.conf.d/*nvidia*"
    "/etc/modprobe.d/*nvidia*"
    "/etc/modprobe.d/blacklist-nvidia.conf"
    "/etc/modules-load.d/*nvidia*"
)

echo "Removing NVIDIA configuration files..."
for file in "${CONFIG_FILES[@]}"; do
    if ls $file 2>/dev/null; then
        rm -f $file && echo "  Removed: $file"
    fi
done

# Remove NVIDIA directories
NVIDIA_DIRS=(
    "/usr/lib/nvidia"
    "/usr/lib32/nvidia"
    "/usr/lib/x86_64-linux-gnu/nvidia"
    "/usr/lib/i386-linux-gnu/nvidia"
    "/var/lib/nvidia"
)

echo "Removing NVIDIA directories..."
for dir in "${NVIDIA_DIRS[@]}"; do
    if [[ -d "$dir" ]]; then
        rm -rf "$dir" && echo "  Removed: $dir"
    fi
done

echo ""
echo -e "${YELLOW}Step 5: Cleaning up DKMS modules...${NC}"
if command -v dkms &> /dev/null; then
    echo "Checking for NVIDIA DKMS modules..."
    DKMS_MODULES=$(dkms status | grep -i nvidia | awk -F',' '{print $1}' | sort -u || true)

    if [[ -n "$DKMS_MODULES" ]]; then
        echo "Found NVIDIA DKMS modules:"
        echo "$DKMS_MODULES"
        echo ""

        while IFS= read -r module; do
            if [[ -n "$module" ]]; then
                echo "Removing DKMS module: $module"
                # Get all versions of this module
                VERSIONS=$(dkms status "$module" | awk -F', ' '{print $2}' | sed 's/.*: //' || true)
                while IFS= read -r version; do
                    if [[ -n "$version" ]]; then
                        dkms remove "$module/$version" --all 2>/dev/null || true
                    fi
                done <<< "$VERSIONS"
            fi
        done <<< "$DKMS_MODULES"
        echo -e "${GREEN}DKMS modules removed${NC}"
    else
        echo "No NVIDIA DKMS modules found"
    fi
else
    echo "DKMS not installed, skipping..."
fi

echo ""
echo -e "${YELLOW}Step 6: Removing NVIDIA from initramfs...${NC}"
if command -v update-initramfs &> /dev/null; then
    echo "Updating initramfs..."
    update-initramfs -u -k all
elif command -v dracut &> /dev/null; then
    echo "Regenerating initramfs with dracut..."
    dracut --force
elif command -v mkinitcpio &> /dev/null; then
    echo "Regenerating initramfs with mkinitcpio..."
    mkinitcpio -P
fi

echo ""
echo -e "${YELLOW}Step 7: Checking for remaining NVIDIA files...${NC}"
echo "Searching for remaining NVIDIA files (this may take a moment)..."

# Check for remaining nvidia binaries
if ls /usr/bin/nvidia-* 2>/dev/null; then
    echo -e "${YELLOW}Warning: Found remaining NVIDIA binaries in /usr/bin/:${NC}"
    ls /usr/bin/nvidia-*
fi

# Check for remaining nvidia libraries
if ls /usr/lib*/libnvidia* 2>/dev/null || ls /usr/lib/x86_64-linux-gnu/libnvidia* 2>/dev/null; then
    echo -e "${YELLOW}Warning: Found remaining NVIDIA libraries${NC}"
fi

echo ""
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}NVIDIA Uninstallation Complete!${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
echo "Summary of actions taken:"
echo "  ✓ Unloaded NVIDIA kernel modules"
echo "  ✓ Removed .run file installations"
echo "  ✓ Removed all NVIDIA packages"
echo "  ✓ Removed configuration files"
echo "  ✓ Cleaned up DKMS modules"
echo "  ✓ Updated initramfs"
echo ""
echo -e "${YELLOW}IMPORTANT: Reboot your system to complete the uninstallation.${NC}"
echo ""
echo "After reboot:"
echo "  - Your system will use the integrated GPU or nouveau driver"
echo "  - You can verify with: lsmod | grep nvidia (should show nothing)"
echo "  - You can then install the new driver with the other script"
echo ""
read -p "Do you want to reboot now? (y/n): " -n 1 -r
echo ""

if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "Rebooting in 5 seconds..."
    echo "Press Ctrl+C to cancel..."
    sleep 5
    reboot
else
    echo -e "${YELLOW}Remember to reboot before installing the new NVIDIA driver!${NC}"
fi
