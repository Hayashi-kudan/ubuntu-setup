#!/usr/bin/env bash
#
# ROS2 Humble Installation Script for Ubuntu 22.04
# Reference: https://docs.ros.org/en/humble/Installation/Ubuntu-Install-Debs.html
#

set -e

echo "=== ROS2 Humble Installation Script for Ubuntu 22.04 ==="
echo ""

# Check Ubuntu version
if [ -f /etc/os-release ]; then
    . /etc/os-release
    if [ "$VERSION_ID" != "22.04" ]; then
        echo "Warning: This script is designed for Ubuntu 22.04 (Jammy)"
        echo "Current version: $VERSION_ID"
        read -p "Continue anyway? [y/N] " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            exit 1
        fi
    fi
else
    echo "Warning: Cannot detect OS version"
fi

# ============================================================
# 1. Locale Setup
# ============================================================
echo ""
echo "=== Setting up locale ==="
sudo apt update
sudo apt install -y locales
sudo locale-gen en_US en_US.UTF-8
sudo update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
export LANG=en_US.UTF-8

echo "Locale setup complete."

# ============================================================
# 2. Enable Universe Repository and Add ROS 2 Repository
# ============================================================
echo ""
echo "=== Adding ROS 2 repository ==="
sudo apt install -y software-properties-common
sudo add-apt-repository -y universe
sudo apt update
sudo apt install -y curl

# Download and install ROS 2 apt source package
export ROS_APT_SOURCE_VERSION=$(curl -s https://api.github.com/repos/ros-infrastructure/ros-apt-source/releases/latest | grep -F "tag_name" | awk -F\" '{print $4}')
echo "ROS APT Source Version: ${ROS_APT_SOURCE_VERSION}"

CODENAME=$(. /etc/os-release && echo ${UBUNTU_CODENAME:-${VERSION_CODENAME}})
curl -L -o /tmp/ros2-apt-source.deb "https://github.com/ros-infrastructure/ros-apt-source/releases/download/${ROS_APT_SOURCE_VERSION}/ros2-apt-source_${ROS_APT_SOURCE_VERSION}.${CODENAME}_all.deb"
sudo dpkg -i /tmp/ros2-apt-source.deb
rm -f /tmp/ros2-apt-source.deb

echo "ROS 2 repository added."

# ============================================================
# 3. Install ROS 2 Packages
# ============================================================
echo ""
echo "=== Installing ROS 2 Humble packages ==="
sudo apt update
sudo apt upgrade -y

# Install ROS 2 Desktop (full installation with RViz, demos, tutorials)
sudo apt install -y ros-humble-desktop

# Install development tools
sudo apt install -y ros-dev-tools

echo "ROS 2 Humble packages installed."

# ============================================================
# 4. Environment Setup
# ============================================================
echo ""
echo "=== Setting up environment ==="

# Add ROS 2 setup to bashrc if not already present
BASHRC_FILE="$HOME/.bashrc"
ROS2_SETUP_LINE="source /opt/ros/humble/setup.bash"

if ! grep -qF "$ROS2_SETUP_LINE" "$BASHRC_FILE"; then
    echo "" >> "$BASHRC_FILE"
    echo "# ROS 2 Humble" >> "$BASHRC_FILE"
    echo "$ROS2_SETUP_LINE" >> "$BASHRC_FILE"
    echo "Added ROS 2 setup to $BASHRC_FILE"
else
    echo "ROS 2 setup already in $BASHRC_FILE"
fi

# ============================================================
# 5. Verify Installation
# ============================================================
echo ""
echo "=== Installation Complete ==="
echo ""
echo "To use ROS 2, either:"
echo "  1. Open a new terminal, or"
echo "  2. Run: source /opt/ros/humble/setup.bash"
echo ""
echo "To verify installation, run:"
echo "  ros2 --help"
echo ""
echo "Try the talker/listener demo:"
echo "  Terminal 1: ros2 run demo_nodes_cpp talker"
echo "  Terminal 2: ros2 run demo_nodes_py listener"
echo ""
