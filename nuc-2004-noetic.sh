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
    ethtool \
    net-tools \
    hwinfo \
    inxi \
    cutecom \
    snapd \
    intel-gpu-tools

sudo apt install python-is-python3 -y

sudo apt install -y gnome-shell=3.36.4-1ubuntu1~20.04.2 gnome-shell-common=3.36.4-1ubuntu1~20.04.2 gnome-shell-extension-prefs=3.36.4-1ubuntu1~20.04.2
sudo apt install -y gnome-tweak-tool

echo "Install kazam, meld"
sudo add-apt-repository -y ppa:sylvain-pineau/kazam
sudo apt install -y kazam
sudo apt install -y meld python3-nautilus
sudo add-apt-repository -y ppa:boamaod/nautilus-compare
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

echo "Install ROS Noetic"
sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | sudo apt-key add -
sudo apt update
sudo apt install -y ros-noetic-desktop-full
sudo apt install -y \
    ros-noetic-rosbag \
    ros-noetic-pcl-ros \
    ros-noetic-rviz \
    ros-noetic-cv-bridge \
    ros-noetic-tf2-geometry-msgs \
    ros-noetic-eigen-conversions \
    ros-noetic-tf-conversions \
    ros-noetic-xacro \
    ros-noetic-robot-state-publisher

echo "source /opt/ros/noetic/setup.bash" >> ~/.bashrc

sudo apt install -y python3-rosdep

echo "Install Third-party libraries"
sudo apt install libpdal-dev
