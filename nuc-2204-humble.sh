#!/usr/bin/env bash
sudo apt update && sudo apt upgrade -y

echo "Install Google Chrome"
wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | sudo gpg --dearmor -o /etc/apt/keyrings/google-chrome.gpg
sudo sh -c 'echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/google-chrome.gpg] https://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list'
sudo apt update
sudo apt install -y google-chrome-stable

echo "Install basic tools"
sudo apt update
sudo apt install -y \
    curl \
    python3-pip \
    git \
    xterm \
    build-essential \
    libeigen3-dev \
    libjsoncpp-dev \
    libspdlog-dev \
    jq \
    cmake \
    terminator \
    vim \
    ethtool \
    net-tools \
    hwinfo \
    inxi \
    cutecom

echo "Install meld"
sudo apt install -y meld

echo "Install simplescreenrecorder"
sudo apt install -y simplescreenrecorder

echo "Install VS code"
sudo apt install -y apt-transport-https
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | sudo tee /etc/apt/keyrings/microsoft.gpg > /dev/null
echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/microsoft.gpg] https://packages.microsoft.com/repos/vscode stable main" | sudo tee /etc/apt/sources.list.d/vscode.list > /dev/null
sudo apt update
sudo apt install -y code

echo "Install foxglove"
sudo snap install foxglove-studio

echo "Install flatpak"
sudo apt install -y flatpak gnome-software-plugin-flatpak
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak install -y --noninteractive flathub org.cloudcompare.CloudCompare

echo "Install ROS2 Humble"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
"${SCRIPT_DIR}/ros2_humble_install.sh"

# Install additional ROS2 packages
sudo apt install -y \
    ros-humble-xacro \
    ros-humble-pcl-* \
    ros-humble-gps-msgs \
    ros-humble-image-transport-plugins \
    ros-humble-rmw-cyclonedds-cpp \
    ros-humble-rqt-tf-tree \
    ros-humble-mavros-msgs \
    ros-humble-diagnostic-updater

# Add colorized output setting (bashrc setup is handled by ros2_humble_install.sh)
if ! grep -qF "export RCUTILS_COLORIZED_OUTPUT=1" ~/.bashrc; then
    echo "export RCUTILS_COLORIZED_OUTPUT=1" >> ~/.bashrc
fi

echo "Install Third-party libraries"
sudo apt install -y \
    libpdal-dev \
    python-is-python3 \
    setserial \
    vlc \
    wmctrl \
    maim

echo "Install pip packages"
pip install --user \
    pyserial \
    sphinx \
    sphinx-rtd-theme \
    myst-parser \
    sphinx-simplepdf \
    evo \
    utm
