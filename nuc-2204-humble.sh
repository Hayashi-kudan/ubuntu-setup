#!/usr/bin/env bash
echo "Install Google Chrome"
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
sudo sh -c 'echo "deb https://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list'
sudo apt update
sudo apt install -y google-chrome-stable
sudo rm /etc/apt/sources.list.d/google.list

echo "Install basic tools"
sudo apt update
sudo apt install -y \
    wget \
    curl \
    ca-certificates \
    python3-pip \
    bash \
    git \
    unzip \
    xterm \
    build-essential \
    libeigen3-dev \
    libjsoncpp-dev \
    libspdlog-dev \
    jq \
    cmake \
    terminator \
    vim \
    gnome-tweak-tool \
    ethtool \
    net-tools \
    hwinfo \
    inxi \
    cutecom \
    snapd \
    intel-gpu-tools

echo "Install kazam, meld"
sudo add-apt-repository ppa:sylvain-pineau/kazam
sudo apt install kazam
sudo apt install -y meld python3-nautilus
sudo add-apt-repository ppa:boamaod/nautilus-compare
sudo apt install -y nautilus-compare
nautilus -q

echo "Install VS code"
sudo apt install software-properties-common apt-transport-https wget -y
wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"
sudo apt update
sudo apt install -y code

echo "Install foxglove"
sudo snap install foxglove-studio

echo "Install flatpak"
sudo apt install -y flatpak gnome-software-plugin-flatpak
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak install flathub org.cloudcompare.CloudCompare

echo "Install ROS2 Humble"
echo $LANG
sudo apt update && sudo apt install software-properties-common && sudo add-apt-repository universe
apt-cache policy | grep universe
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(source /etc/os-release && echo $UBUNTU_CODENAME) main" | sudo tee /etc/apt/sources.list.d/ros2.list > /dev/null
sudo apt update && sudo apt upgrade
sudo apt install -y ros-humble-desktop
sudo apt install -y build-essential python3-colcon-common-extensions python3-rosdep ros-humble-rmw-cyclonedds-cpp

echo "source /opt/ros/humble/setup.bash" >> ~/.bashrc
