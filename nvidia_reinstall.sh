#!/bin/bash

# Script to remove current NVIDIA driver and install driver using official method
# Follows NVIDIA official installation guide for Ubuntu
# Author: Generated for NVIDIA driver reinstallation
# Date: 2025-11-20

set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${GREEN}NVIDIA Driver Installation Script (Official Method)${NC}"
echo "===================================================="
echo ""

# Check if running as root
if [[ $EUID -ne 0 ]]; then
   echo -e "${RED}Error: This script must be run as root${NC}"
   echo "Please run: sudo bash $0"
   exit 1
fi

# Detect Ubuntu version
UBUNTU_VERSION=$(lsb_release -rs)
echo "Detected Ubuntu version: $UBUNTU_VERSION"
echo ""

echo -e "${YELLOW}Step 1: Checking for Nouveau driver...${NC}"
# Check if nouveau is loaded (conflicts with NVIDIA)
if lsmod | grep -q nouveau; then
    echo -e "${YELLOW}Nouveau driver detected. Will blacklist it.${NC}"

    # Create blacklist file for nouveau
    cat > /etc/modprobe.d/blacklist-nouveau.conf <<EOF
blacklist nouveau
options nouveau modeset=0
EOF

    echo "Nouveau has been blacklisted. A reboot will be required after this script."
    NEED_REBOOT=1
else
    echo "Nouveau driver not loaded."
    NEED_REBOOT=0
fi

echo ""
echo -e "${YELLOW}Step 2: Removing current NVIDIA driver...${NC}"
# Try to uninstall using nvidia-uninstall if it exists
if command -v nvidia-uninstall &> /dev/null; then
    echo "Running nvidia-uninstall..."
    nvidia-uninstall --silent || true
fi

# Remove NVIDIA packages (for both open and proprietary drivers)
echo "Removing existing NVIDIA packages..."
apt-get remove --purge -y 'nvidia-*' 'libnvidia-*' || true
apt-get autoremove -y || true

echo ""
echo -e "${YELLOW}Step 3: Adding graphics-drivers PPA and updating package list...${NC}"
# Add NVIDIA graphics drivers PPA for latest drivers
add-apt-repository ppa:graphics-drivers/ppa -y
apt-get update

echo ""
echo -e "${YELLOW}Step 4: Checking GPU requirements...${NC}"
# Check if GPU requires open kernel modules (newer GPUs like RTX 5090)
GPU_ID=$(lspci -n | grep '10de:' | grep '0300:' | awk '{print $3}' | cut -d':' -f2)

if [[ -z "$GPU_ID" ]]; then
    echo -e "${RED}Warning: Could not detect GPU ID${NC}"
    USE_OPEN_MODULES=false
else
    echo "Detected GPU ID: $GPU_ID"

    # RTX 50 series and newer require open kernel modules
    # Device IDs 2b00 and higher are RTX 50 series
    if [[ "$GPU_ID" == "2b85" ]] || [[ "$GPU_ID" > "2b00" ]]; then
        echo -e "${YELLOW}This GPU (RTX 5090) requires NVIDIA open kernel modules${NC}"
        USE_OPEN_MODULES=true
    else
        echo "This GPU can use standard driver"
        USE_OPEN_MODULES=false
    fi
fi

echo ""
echo -e "${YELLOW}Step 5: Detecting recommended NVIDIA driver...${NC}"
# Use ubuntu-drivers to detect recommended driver
RECOMMENDED_DRIVER=$(ubuntu-drivers devices | grep recommended | awk '{print $3}')

if [[ -z "$RECOMMENDED_DRIVER" ]]; then
    echo -e "${YELLOW}No recommended driver found. Listing available drivers:${NC}"
    ubuntu-drivers devices
    echo ""
    echo -e "${BLUE}You can manually install a specific driver version, for example:${NC}"
    echo "  apt install nvidia-driver-550-open"
    echo "  apt install nvidia-driver-565-open"
    echo ""
    read -p "Enter the driver package name to install (e.g., nvidia-driver-565-open): " DRIVER_PACKAGE

    if [[ -z "$DRIVER_PACKAGE" ]]; then
        echo -e "${RED}No driver specified. Exiting.${NC}"
        exit 1
    fi
else
    echo "Recommended driver: $RECOMMENDED_DRIVER"

    # For GPUs requiring open modules, ensure we use the -open variant
    if [[ "$USE_OPEN_MODULES" == true ]]; then
        if [[ ! "$RECOMMENDED_DRIVER" =~ "-open" ]]; then
            DRIVER_PACKAGE="${RECOMMENDED_DRIVER}-open"
            echo -e "${YELLOW}Switching to open kernel module variant: $DRIVER_PACKAGE${NC}"
        else
            DRIVER_PACKAGE="$RECOMMENDED_DRIVER"
        fi
    else
        DRIVER_PACKAGE="$RECOMMENDED_DRIVER"
    fi
fi

echo ""
echo -e "${YELLOW}Step 6: Installing NVIDIA driver: $DRIVER_PACKAGE${NC}"
apt-get install -y "$DRIVER_PACKAGE"

# Check if installation was successful
if [[ $? -eq 0 ]]; then
    echo -e "${GREEN}NVIDIA driver installation completed successfully!${NC}"
else
    echo -e "${RED}NVIDIA driver installation failed!${NC}"
    exit 1
fi

echo ""
echo -e "${YELLOW}Step 7: Rebuilding initramfs...${NC}"
# Rebuild initramfs to include new driver
update-initramfs -u

echo ""
echo -e "${GREEN}Installation complete!${NC}"
echo ""
echo -e "${YELLOW}IMPORTANT: You must reboot for the new driver to take effect.${NC}"

if [[ $NEED_REBOOT -eq 1 ]]; then
    echo -e "${RED}Nouveau driver was blacklisted - reboot is REQUIRED.${NC}"
fi

echo ""
echo "After reboot, verify installation with: nvidia-smi"
echo ""
echo "Options:"
echo "1. Reboot now (recommended)"
echo "2. Reboot later manually"
echo ""
read -p "Do you want to reboot now? (y/n): " -n 1 -r
echo ""

if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "Rebooting in 5 seconds..."
    echo "Press Ctrl+C to cancel..."
    sleep 5
    reboot
else
    echo -e "${YELLOW}Remember to reboot your system to load the new NVIDIA driver.${NC}"
fi
